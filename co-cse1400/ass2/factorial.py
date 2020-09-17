def factorial(n):
    if (n<=1): return 1
    return n * factorial(n-1)

def factorial_assembly(r8, r9):
    if (r9==0):
        r9 = r8

    if (r8==1):
        return r9
    r8 -= 1 
    r9 = r8*r9
    return factorial_assembly(r8, r9)


print(factorial(5))
print(factorial_assembly(5, 0))


print(factorial(42))
print(factorial_assembly(42, 0))
