A = [1 2 4 6];
B = [2 3 4 5];
C = [5 7 2 4];
D = [9 2 7 5];
E = [8 4 6 4];
F = [30 70 50 10];

O = [1 2 4 6];

Sum1 = A + B + C + D + E;
Sum2 = F + B + C + D + E;

D1 = dot(Sum1, O);
D2 = dot(Sum2, O);