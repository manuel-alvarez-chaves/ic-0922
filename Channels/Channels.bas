Attribute VB_Name = "Módulo1"
Option Explicit

Sub Aleatorizar()

ActiveSheet.Calculate

End Sub

Function YN(Q As Double, n As Double, S0 As Double, B As Double, z1 As Double, z2 As Double)

Dim y0, y1, tol, T, A, P, dP, dA, F, dF As Double

y0 = ((Q / B) ^ 2 / 9.81) ^ (1 / 3)
y1 = 0
tol = 1

Do While tol > 0.0001
T = B + y0 * (z1 + z2)
A = (y0 / 2) * (B + T)
P = B + y0 * (Sqr(1 + z1 * z1) + Sqr(1 + z2 * z2))
dP = Sqr(1 + z1 * z1) + Sqr(1 + z2 * z2)
dA = B + y0 * (z1 + z2)

F = n * Q * P ^ (2 / 3) - A ^ (5 / 3) * Sqr(S0)
dF = (2 / 3) * n * Q * P ^ (-1 / 3) * dP - (5 / 3) * A ^ (2 / 3) * Sqr(S0) * dA

y1 = y0 - F / dF
tol = Abs(y1 - y0)
y0 = y1
Loop

YN = y0

End Function

Function YC(Q As Double, B As Double, z1 As Double, z2 As Double)

Dim y0, y1, tol, A, T, D, dA, dT, dD, F, dF As Double

y0 = ((Q / B) ^ 2 / 9.81) ^ (1 / 3)
y1 = 0
tol = 1

Do While tol > 0.00001
T = B + y0 * (z1 + z2)
dT = z1 + z2
A = B * y0 + (y0 ^ 2) / 2 * (z1 + z2)
dA = B + y0 * (z1 + z2)

F = (Q ^ 2) * T / 9.81 - A ^ 3
dF = (Q ^ 2 / 9.81) * dT - 3 * (A ^ 2) * dA

y1 = y0 - F / dF
tol = Abs(y1 - y0)
y0 = y1
Loop

YC = y0


End Function

Function YNCircular(Q As Double, n As Double, S0 As Double, D As Double)

Dim y0, y1, y2, tol, O0, O1, A0, A1, P0, P1, F0, F1 As Double

y0 = D / 2
y1 = 0.8 * D
y2 = 0
tol = D

O1 = 2 * Application.Acos(1 - 2 * (y1 / D))
A1 = (D ^ 2) * (O1 - Sin(O1)) / 8
P1 = (D / 2) * O1

If (1 / n) * A1 * (A1 / P1) ^ (2 / 3) * Sqr(S0) < Q Then
    YNCircular = "Supera capacidad!"
    Exit Function
End If

Do While tol > 0.00001

    O0 = 2 * Application.Acos(1 - 2 * (y0 / D))
    A0 = (D ^ 2) * (O0 - Sin(O0)) / 8
    P0 = (D / 2) * O0
    O1 = 2 * Application.Acos(1 - 2 * (y1 / D))
    A1 = (D ^ 2) * (O1 - Sin(O1)) / 8
    P1 = (D / 2) * O1
    
    F0 = n * Q * P0 ^ (2 / 3) - A0 ^ (5 / 3) * Sqr(S0)
    F1 = n * Q * P1 ^ (2 / 3) - A1 ^ (5 / 3) * Sqr(S0)
    
    y2 = y0 - (y1 - y0) / (F1 - F0) * F0
    tol = Abs(y0 - y2)
    y0 = y2
Loop

YNCircular = y2

End Function

Function YCCircular(Q As Double, n As Double, S0 As Double, D As Double)

Dim y0, y1, y2, tol, O0, O1, T0, T1, A0, A1, P0, P1, F0, F1 As Double

y0 = D / 2
y1 = D
y2 = 0
tol = D

O1 = 2 * Application.Acos(1 - 2 * (y1 / D))
A1 = (D ^ 2) * (O1 - Sin(O1)) / 8
P1 = (D / 2) * O1

If (1 / n) * A1 * (A1 / P1) ^ (2 / 3) * Sqr(S0) < Q Then
    YCCircular = "Supera capacidad!"
    Exit Function
End If

Do While tol > 0.00001

    O0 = 2 * Application.Acos(1 - 2 * (y0 / D))
    A0 = (D ^ 2) * (O0 - Sin(O0)) / 8
    T0 = D * Sin(O0 / 2)
    O1 = 2 * Application.Acos(1 - 2 * (y1 / D))
    A1 = (D ^ 2) * (O1 - Sin(O1)) / 8
    T1 = D * Sin(O1 / 2)
        
    F0 = (Q ^ 2) / 9.81 * T0 - A0 ^ 3
    F1 = (Q ^ 2) / 9.81 * T1 - A1 ^ 3
    
    y2 = y0 - (y1 - y0) / (F1 - F0) * F0
    tol = Abs(y1 - y0)
    y0 = y1
    y1 = y2
Loop

YCCircular = y2


End Function
