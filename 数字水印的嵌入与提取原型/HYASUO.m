function result=HYASUO(I)
yuzhi=50;
A=I(:,:,1);
B=I(:,:,2);
C=I(:,:,3);
[c,k]=size(A);
for i=1:c
    for j=1:k
        if A(i,j)<=yuzhi
            A(i,j)=0;
        end
        if B(i,j)<=yuzhi
            B(i,j)=0;
        end
        if C(i,j)<=yuzhi
            C(i,j)=0;
        end
    end
end
result=cat(3,A,B,C);
