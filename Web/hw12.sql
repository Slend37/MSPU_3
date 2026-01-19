DROP TABLE IF EXISTS hr_import_lines;
CREATE TABLE hr_import_lines (
  id serial PRIMARY KEY,
  source_file text NOT NULL,      -- имя файла-источника
  line_no int NOT NULL,           -- номер строки в файле
  raw_line text NOT NULL,         -- исходная необработанная строка
  imported_at timestamp with time zone default now(),
  note text                       -- служебная метка (для ревью)
);

INSERT INTO hr_import_lines (source_file, line_no, raw_line, note) VALUES
-- Контактные строки с email в угловых скобках и без
('candidates_2025_10.csv', 1, 'Ivan Ivanov <ivan.ivanov@example.com>, +7 (912) 345-67-89, \"python,sql\"', 'contact record'),
('candidates_2025_10.csv', 2, 'Мария Смирнова, maria.smirnova@company.co, 8-912-3456789, \"python,django\"', 'contact record'),
('candidates_2025_10.csv', 3, 'Petrov <not-an-email@@example..com>, 09123456789, \"rust, systems\"', 'broken email'),

-- Записи о оборудовании / внутренние ID (артикулы, SKU, asset IDs)
('assets_import.csv', 10, 'ASSET: AB-123-XY; location: HQ; qty: 2', 'asset record'),
('assets_import.csv', 11, 'asset: zx9999; note: legacy-id', 'asset record'),

-- Теги/скиллы в одной колонке, через запятую, с разными пробелами
('skills_teams.csv', 1, 'tags: sql, postgres, regex,  performance', 'tags field'),
('skills_teams.csv', 2, 'tags: fastapi,python', 'tags field'),
('skills_teams.csv', 3, 'tags: sql,, ,postgres', 'possible empty tags'),

-- «Грязные» CSV-поля: кавычки и запятые внутри полей (адреса, зарплаты с разделителем тысяч)
('payroll_dirty.csv', 5, '\"Ivanov, Ivan\", Москва, \"30,000\"', 'csv row with commas'),
('payroll_dirty.csv', 6, '\"Sidorova, Anna\", "St.Petersburg, Nevsky", "1,200,000"', 'csv row with many commas'),

-- Логи обработки и сообщения об ошибках разного регистра
('import_log.txt', 201, 'INFO: Started import of candidates_2025_10.csv', 'log'),
('import_log.txt', 202, 'Warning: missing email for line 3', 'log'),
('import_log.txt', 203, 'error: failed to parse csv_row at line 6', 'log'),
('import_log.txt', 204, 'Error: phone number invalid', 'log'),

-- Ловушки/нестандартные случаи (реалистичные, чтобы выявить наивные решения)
('candidates_2025_10.csv', 20, 'Contact: bad@-domain.com, +7 912 ABC-67-89, \"node, js\"', 'trap-invalid-email-and-phone'),
('assets_import.csv', 12, 'SKU: 12-AB-!!; qty: one', 'trap-bad-sku');

-- 1
SELECT id, source_file, line_no, raw_line
FROM hr_import_lines 
WHERE raw_line ~ '[\w\-.]+@[\w\-.]+\.\w{2,}';

-- 2
SELECT id, source_file, line_no, raw_line
FROM hr_import_lines 
WHERE raw_line !~ '[\w\-.]+@[\w\-.]+\.\w{2,}';

-- 3
SELECT id, source_file, line_no, raw_line
FROM hr_import_lines 
WHERE source_file = 'import_log.txt' 
  AND raw_line ~* 'error';

-- 4
SELECT id, source_file, line_no, raw_line
FROM hr_import_lines 
WHERE source_file = 'import_log.txt' 
  AND raw_line !~* 'error';

-- 5
SELECT 
  id,
  source_file,
  line_no,
  (regexp_match(raw_line, '[\w\-.]+@[\w\-.]+\.\w{2,}'))[1] as email
FROM hr_import_lines 
WHERE raw_line ~ '[\w\-.]+@[\w\-.]+\.\w{2,}';

-- 6
SELECT 
  id,
  source_file,
  line_no,
  unnest(regexp_matches(raw_line, '[A-Z]{2}-\d{3}-[A-Z]{2}', 'gi')) as asset_code
FROM hr_import_lines 
WHERE raw_line ~* '[A-Z]{2}-\d{3}-[A-Z]{2}';

-- 7
SELECT 
  id,
  source_file,
  line_no,
  regexp_replace(raw_line, '[^\d]+', '', 'g') as normalized_phone
FROM hr_import_lines 
WHERE raw_line ~ '\+?[\d\s\-\(\)]+';

-- 8
SELECT 
  id,
  source_file,
  line_no,
  array_remove(
    regexp_split_to_array(
      regexp_replace(raw_line, '^.*tags?:', '', 'i'),
      '\s*,\s*'
    ),
    ''
  ) as tags_array
FROM hr_import_lines 
WHERE raw_line ~* 'tags?';

-- 9
SELECT 
  id,
  source_file,
  line_no,
  field_num,
  field_value
FROM (
  SELECT 
    id,
    source_file,
    line_no,
    regexp_split_to_table(
      regexp_replace(raw_line, '"([^"]*)"', '\1', 'g'),
      ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
    ) as field_value,
    row_number() over (partition by id order by 1) as field_num
  FROM hr_import_lines 
  WHERE source_file = 'payroll_dirty.csv'
) t
ORDER BY id, field_num;

-- 10
SELECT 
  id,
  source_file,
  line_no,
  regexp_replace(raw_line, 'error', 'ERROR', 'gi') as normalized_log
FROM hr_import_lines 
WHERE source_file = 'import_log.txt';