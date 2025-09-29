def count_calls(func):
    def wrapper(*args, **kwargs):
        wrapper.calls += 1
        return func(*args, **kwargs)
    wrapper.calls = 0
    return wrapper

@count_calls
def greet(name):
    return f"Hello, {name}!"

print(greet("Danila"))
print(greet("World"))
print(greet("lalala"))

print(greet.calls)
