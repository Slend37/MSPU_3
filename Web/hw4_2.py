def repeat(times):
    def decorator(func):
        def wrapper():
            for i in range(times):
                wrapper.list.append(func())
            return wrapper.list
        wrapper.list = []
        return wrapper
    return decorator


@repeat(10)
def hello():
    return "hi"

print(hello())  # ["hi", "hi", "hi"]