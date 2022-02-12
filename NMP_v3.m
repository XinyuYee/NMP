function ind = NMP_v3(X,Y,lambda,numNeigh1,num_true,sigma)%,lambda,numNeigh1,num_true,sigma
%% Default Parameter
% close all
% clear
% lambda = 0.6;
% numNeigh1 = 10;
% sigma = 15;
% num_true = 6;
% addpath('D:\MATLAB\R2016a\bin\LPM')
%% load image

% 
% fn_l = 'D:\MATLAB\R2016a\bin\LPM\data\bearD0.jpg';
% fn_r = 'D:\MATLAB\R2016a\bin\LPM\data\bearD2.jpg';
% Ia = imread(fn_l);
% Ib = imread(fn_r);
% load  D:\MATLAB\R2016a\bin\LPM\data\bearD02.mat;


% Ia = imresize(Ia, [size(Ib,1), size(Ib,2)]);
% if size(Ia,3) == 1
%     Ia = repmat(Ia,[1,1,3]);
%     Ib = repmat(Ib,[1,1,3]);
% end
% %% 
% choose_point = 17;
% numNeigh1 = 12;
%nn = 6;
% sigma = 10;
N = size(X,1);
tic;
X = double(X); Y = double(Y);
[nX, nY, normal]=norm2(X,Y);
% X_ori = X; Y_ori = Y;
X = nX; Y = nY;
Xt = X';Yt = Y';
X1 = Xt(1,:); X2 = Xt(2,:);
Y1 = Yt(1,:); Y2 = Yt(2,:);
vec=Xt-Yt;
%d2=vec(1,:).^2+vec(2,:).^2;
vx = vec(1, :); vy = vec(2, :);
kdtreeX = vl_kdtreebuild(Xt);
[neighborX, ~] = vl_kdtreequery(kdtreeX, Xt, Xt, 'NumNeighbors', numNeigh1+1);
index = neighborX(2:numNeigh1+1, :);
vxi = vx(index); vyi = vy(index);
ave_x = sum(vxi,1)/numNeigh1;
ave_y = sum(vyi,1)/numNeigh1;
vec_diff = (vxi-ave_x).^2+(vyi-ave_y).^2;
[~,b] = sort(vec_diff);
for i=1:N
    temp = index(:,i);
    new_index(:,i) = temp(b(1:num_true,i));
end

p = exp(-sqrt((X1(new_index)-X1).^2+(X2(new_index)-X2).^2)/sigma);
%p_w = p./sum(p);

q = exp(-sqrt((Y1(new_index)-Y1).^2+(Y2(new_index)-Y2).^2)/sigma);
%q = q./sum(q);

%temp = abs(log(abs(p-q)+1));

temp = p.*abs(log(p./q)); 
%p_w = [];
%[temp1,temp_ind] = sort(temp);
% for i=1:N
%     ttt = p(:,i);
%     p_w(:,i) = ttt(temp_ind(1:nn,i));
% end

cost = (sum(temp))*10;%p(temp_ind(1:nn,:)).*
ind = find((cost < lambda)==1);
% toc
% figure;
% for putative_index = 1:N
%     if find (CorrectIndex == putative_index)
%         plot(putative_index, cost(putative_index),'o','color','b');
%     else
%         plot(putative_index, cost(putative_index),'o','color','r');
%     end
%     hold on;
% end
% figure;
% ind = find((cost > 0.48)==1);
% [FP,FN] = plot_matches(Ia, Ib, X_ori, Y_ori, (ind), CorrectIndex);


