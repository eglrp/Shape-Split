function skltn = SkeletonGrow1(bw,ro,mark)
%---------------------------------------
%Name:  skltn = SkeletonGrow(bw,ro)
%Desc:  从二值图中获得形体的骨架
%       bw是一个n×n的矩阵，非0点表示形
%       体的位置
%Para:  bw——n×n的矩阵，非0点表示形体
%           的位置
%Return:skltn——与bw同维的矩阵，非0点表
%        示骨架点,其数值表示最大圆的半径
%--------------------------------------
[m,n] = size(bw);
skltn = zeros(m,n);
%第一步，进行距离变换
[dist,lab] = bwdist(bw);          %dist距离变换结果矩阵，lab列优先的一维坐标矩阵

% the star point of the skeleton
root = find(dist == max(max(dist)));             %find返回距离变换最大值的列优先标号
root = root(1);                                  %骨架起始点，取列优先标号中的第一个

%accsee matrix   存取矩阵
bAccess = zeros(m,n);

curPoint = [0,0];
[curPoint(2),curPoint(1)] = Lab2Pos(root,m,n);    %由标号获取，起始点的列行数

skltn(curPoint(1),curPoint(2)) = dist(curPoint(1),curPoint(2));   %dist不起函数作用。得到起始种子点的距离变换矩阵中的值，最大最大圆半径。
bAccess(curPoint(1),curPoint(2)) = 1;                                %骨架定义灰度值定义为1。

%access stack                  访问堆栈
AccessStack = [curPoint];            %从该坐标开始堆栈

% from the start point, check the 4-adjent points and the 8-adjent points
while (length(AccessStack) ~= 0);
    curPoint = AccessStack(1,:);
    [tm,tn] = size(AccessStack);
    AccessStack = AccessStack(2:tm,:);
    nAdj = 0;
    for i = max(curPoint(1)-1,1):min(curPoint(1)+1,m);
        for j = max(curPoint(2)-1,1):min(curPoint(2)+1,n);
            if bAccess(i,j) == 0;
                skltn(i,j) = CheckSkeleton1(bw,dist,lab,i,j,ro,mark);
                if skltn(i,j) ~= 0;
                    bAccess(i,j) = 1;
                    nAdj = nAdj+1;
                    AccessStack = [[i,j];AccessStack];
                else
                    bAccess(i,j) = -1;
                end;
            end;
        end;
    end;
    
end;
     
