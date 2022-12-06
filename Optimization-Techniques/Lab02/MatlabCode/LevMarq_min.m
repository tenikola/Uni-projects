function [x, y, m, k] = LevMarq_min(xstart,ystart,e,gamma,gradf,hess,f)
    %this function takes as input a starting x, a starting y, a funtion,
    %its gradient and it's hessian matrix returns a possible minimum point
    %(x,y) as well as the iterations we needed to find it, using the Levenberg-Marquardt 
    %method and selecting the step that minimizes f(xk+dk*gk)   

    syms x1;
    syms x2;
    k = 1;

    x(k) = xstart;
    y(k) = ystart;

while norm(gradf(x(k),y(k)))>=e
    hmatrix = double(hess(x(k),y(k)));
    [new_hess,mk] = make_positive(hmatrix);
    m(k) = mk;
    diff(:,k) = -gradf(x(k),y(k));
    
    equation1 = new_hess(1,1)*x1 + new_hess(1,2)*x2 == diff(1,k);
    equation2 = new_hess(2,1)*x1 + new_hess(2,2)*x2 == diff(2,k);
    [A,B] = equationsToMatrix([equation1, equation2], [x1, x2]);
    dk(:,k) = linsolve(A,B);

    h = @(gk) f(x(k) + gk*diff(1,k),y(k) + gk*diff(2,k));
    gamma(k+1) = fminsearch(h,0.1);
    if gamma(k+1) > 5
        gamma(k+1) = 5;
    end
    
    x(k+1) = x(k)+(gamma(k+1)*dk(1,k));
    y(k+1) = y(k)+(gamma(k+1)*dk(2,k));

    k = k + 1;

    if(k > 1000)
        disp('1000 steps and no result');
        break;
    end
end
disp("xmin");
disp(x(k));
disp("ymin");
disp(y(k));
end