#Code written in Python to calculate normal depth in a trapezoidal channel using a Newton-Raphson scheme and critical depth in a circular channel using the method of the secant.
#Additional function for the calculation of friction factor in a pipe.

def yn(Q, n, S0, B, z1, z2):
	y0 = ((Q/B)^2/9.81)^(1/3)
	y1 = 0
	tol = 1
	while tol > 0.001:
		#Geometry
		T = B + y0*(z1 + z2)
		A = (y0/2)*(B + T)
		P = B + y0*(Sqrt(1 + z1^2) + Sqrt(1 + z2^2))
		dP = Sqrt(1 + z1^2) + Sqrt(1 + z2^2)
		dA = B + y0*(z1 + z2)
		
		F = n*Q*P^(2/3) - A^(5/3)*Sqrt(S0)
		dF = (2/3)*n*Q*P^(-1/3)*dP - (5/3)*A^(2/3)*Sqrt(S0)*dA
		
		#Newton-Raphson
		y1 = y0 - F/dF
		tol = Abs(y1 - y0)
		y0 = y1
	return y0

def yccircular(Q, D):
	y0 = D/2
	y1 = 0.8*D
	y2 = 0
	tol = D
	while tol > 0.001:
		#Geometry
		O0 = 2*Acos(1 - 2*(y0/D))
		A0 = (D^2)*(O0 - Sin(O0))/8
		T0 = D*Sin(O0/2)
		O1 = 2*Acos(1 - 2*(y1/D))
		A1 = (D^2)*(O1 - Sin(O1))/8
		T01 = D*Sin(O1/2)
		
		F0 = (Q^2)/9.81*T0 - A0^3
		F1 = (Q^2)/9.81*T1 - A1^3
		
		#Secant
		y2 = y0 - (y1 - y0)/(F1 - F0)*F0
		tol = Abs(y1 - y0)
		y0 = y1
		y1 = y2
	return y2

def ffactor(e,D,Re):
	f0 = 1/(-2*log(e/(3.7*D)))^2
	f1 = 1/(-2*log(e/(3.7*D) + 2.51/(Re*Sqrt(f0))))^2
	tol = 1
	while tol > 0.00001
		f0 = f1
		f1 = 1/(-2*log(e/(3.7*D) + 2.51/(Re*Sqrt(f0))))^2
		tol = Abs(f1 - f0)
	return f1