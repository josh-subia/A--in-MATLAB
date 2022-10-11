function reduced = reduce_collinear_points(x,y)
%given X and Y to a whole path 
%reduce waypoints in a given path 
%return reduced path 
%disp('in "reduce_colinear_points');
a=x(:)';
b=y(:)';
before=numel(a);
after=before+1;
tol=1e-5;
while after~=before
    %fprintf('before: %d   after: %d \n',before,after);
    before = numel(a);
    X = [a(1:end-1);a(2:end);[a(3:end),a(1)]];
    Y = [b(1:end-1);b(2:end);[b(3:end),b(1)]];
    A = polyarea(X,Y);
    I = [false,abs(A)<tol];
    if after~=before
        check = double(I);
        for i = 2:length(I)-12
            %Reducing redundant WPs 
            %add more statements to reudce more WPs 
            if check(i) == 0 && (check(i+1) == 0 || check(i+2) == 0 ||...
                check(i+3) == 0 || check(i+4) == 0 || check(i+5) == 0 ||...
                check(i+6) == 0 || check(i+7) == 0 || check(i+8) == 0 ||...
                check(i+9) == 0 || check(i+10) == 0 || check(i+11) == 0 ||...
                check(i+12) == 0 || check(i+13) == 0 || check(i+14) == 0 ||...
                check(i+15) == 0 || check(i+16) == 0 || check(i+17) == 0 ||...
                check(i+18) == 0 || check(i+19) == 0 || check(i+20) == 0)
                check(i+1) = 1; check(i+2) = 1;
                check(i+3) = 1; check(i+4) = 1; check(i+5) = 1;
                check(i+6) = 1; check(i+7) = 1; check(i+8) = 1;
                check(i+9) = 1; check(i+10) = 1; check(i+11) = 1;
                check(i+12) = 1; check(i+13) = 1; check(i+14) = 1;
                check(i+15) = 1; check(i+16) = 1; check(i+17) = 1;
                check(i+18) = 1; check(i+19) = 1; check(i+20) = 1;
            end
        end 
          I = logical(check);
    end 
    %Gets rid of redudant WPs
    a(I) = [];
    b(I) = [];
    after = numel(a);
end

%plots Waypoints
plot(a,b,'bo');

%Flips points into the correct order 
reduced(:,1) = fliplr(a);
reduced(:,2) = fliplr(b);


end 



