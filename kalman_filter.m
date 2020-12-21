function [K,C,Y] = kalman_filter(n,position,H,A,B,C,Q,R,Y)



i = (n-1)*2+1;
K = C(:,i:i+1)*H'*inv(H*C(:,i:i+1)*H'+R); %%���㿨��������
Y(:,n) = Y(:,n)+K*(position-H*Y(:,n));%%״̬����
Y(:,n+1) = A*Y(:,n);%%״̬Ԥ��
C(:,i:i+1) = (eye(2,2)-K*H)*C(:,i:i+1);%%Э�������
C(:,i+2:i+3) = A*C(:,i:i+1)*A'+B*Q*B';%%Э�������Ԥ��



end

