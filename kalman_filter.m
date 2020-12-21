function [K,C,Y] = kalman_filter(n,position,H,A,B,C,Q,R,Y)



i = (n-1)*2+1;
K = C(:,i:i+1)*H'*inv(H*C(:,i:i+1)*H'+R); %%计算卡尔曼增益
Y(:,n) = Y(:,n)+K*(position-H*Y(:,n));%%状态更新
Y(:,n+1) = A*Y(:,n);%%状态预测
C(:,i:i+1) = (eye(2,2)-K*H)*C(:,i:i+1);%%协方差更新
C(:,i+2:i+3) = A*C(:,i:i+1)*A'+B*Q*B';%%协方差矩阵预测



end

