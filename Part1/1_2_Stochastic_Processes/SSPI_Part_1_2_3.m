M = 3
N = 2

Ar=rand(M,1)*ones(1,N)
Mr=rand(M,1)*ones(1,N)
v=(rand(M,N)-0.5).*Mr+Ar

a = 0.5;
m = 3;
test = rand(M,N)
test1 = test - 0.5
test2 = test1*m
test3 = test2 + a