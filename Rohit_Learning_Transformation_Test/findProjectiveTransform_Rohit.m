function tform = findProjectiveTransform_Rohit(uv,xy)
%
% For a projective transformation:
%
% u = (Ax + By + C)/(Gx + Hy + I)
% v = (Dx + Ey + F)/(Gx + Hy + I)
%
% Assume I = 1, multiply both equations, by denominator:
%
% u = [x y 1 0 0 0 -ux -uy] * [A B C D E F G H]'
% v = [0 0 0 x y 1 -vx -vy] * [A B C D E F G H]'
%
% With 4 or more correspondence points we can combine the u equations and
% the v equations for one linear system to solve for [A B C D E F G H]:
%
% [ u1  ] = [ x1  y1  1  0   0   0  -u1*x1  -u1*y1 ] * [A]
% [ u2  ] = [ x2  y2  1  0   0   0  -u2*x2  -u2*y2 ]   [B]
% [ u3  ] = [ x3  y3  1  0   0   0  -u3*x3  -u3*y3 ]   [C]
% [ u1  ] = [ x4  y4  1  0   0   0  -u4*x4  -u4*y4 ]   [D]
% [ ... ]   [ ...                                  ]   [E]
% [ un  ] = [ xn  yn  1  0   0   0  -un*xn  -un*yn ]   [F]
% [ v1  ] = [ 0   0   0  x1  y1  1  -v1*x1  -v1*y1 ]   [G]
% [ v2  ] = [ 0   0   0  x2  y2  1  -v2*x2  -v2*y2 ]   [H]
% [ v3  ] = [ 0   0   0  x3  y3  1  -v3*x3  -v3*y3 ]
% [ v4  ] = [ 0   0   0  x4  y4  1  -v4*x4  -v4*y4 ]
% [ ... ]   [ ...                                  ]  
% [ vn  ] = [ 0   0   0  xn  yn  1  -vn*xn  -vn*yn ]
%
% Or rewriting the above matrix equation:
% U = X * Tvec, where Tvec = [A B C D E F G H]'
% so Tvec = X\U.
%

[uv,normMatrix1] = images.geotrans.internal.normalizeControlPoints(uv);
[xy,normMatrix2] = images.geotrans.internal.normalizeControlPoints(xy);

minRequiredNonCollinearPairs = 4;
M = size(xy,1);
x = xy(:,1);
y = xy(:,2);
vec_1 = ones(M,1);
vec_0 = zeros(M,1);
u = uv(:,1);
v = uv(:,2);

U = [u; v];

X = [x      y      vec_1  vec_0  vec_0  vec_0  -u.*x  -u.*y;
     vec_0  vec_0  vec_0  x      y      vec_1  -v.*x  -v.*y  ];

% We know that X * Tvec = U
if rank(X) >= 2*minRequiredNonCollinearPairs 
    Tvec = X \ U;    
else
    error(message('images:geotrans:requiredNonCollinearPoints', minRequiredNonCollinearPairs, 'projective'))
end

% We assumed I = 1;
Tvec(9) = 1;

Tinv = reshape(Tvec,3,3)

Tinv = normMatrix2 \ (Tinv * normMatrix1);

T = inv(Tinv);
T = T ./ T(3,3);

tform = projective2d(T);