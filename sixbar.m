function main
% 1.输入已知数据
clear;
i1=60;
i2=120;
xd=65;
e=0;
hd = pi/180; %一度对应的弧度
du=180/pi;  %一弧度对应的度数
omega1=10;  %主动件角速度
alpha1=0;   %主动件角加速度
t=hd/10;    %主动件运动单位圆周角度1°对应的时间

% 2.使用子函数计算出曲柄滑块的位置，速度，加速度。
% 通过一个循环遍历曲柄的每一个角位置（从 0 到 720 度），使用 sli_crank 函数计算每个角度下连杆和滑块的参数。
for n1 = 1:721
    theta1(n1) = (n1 - 1) * hd;          
    [theta2(n1), s3(n1), s5(n1), omega2(n1), v3(n1), alpha2(n1), a3(n1)] = sli_crank(theta1(n1), omega1, alpha1, i1, i2, e, xd);
    if n1 == 1
        s5_prev = s5(n1); % 保存前一个位置的滑块位移
    else
        thetas5(n1) = s5(n1) - s5_prev; % 计算相邻两次位置的滑块位移
        s5_prev = s5(n1); % 更新前一个位置的滑块位移
    end
end

for n2 = 1:720
    v5(n2) = thetas5(n2) / t; 
    if n2 == 1
        v5_prev = v5(n2); % 保存前一个位置的滑块速度
    else
        thetav5(n2) = v5(n2) - v5_prev; % 计算相邻两次速度的变化量
        v5_prev = v5(n2); % 更新前一个位置的滑块速度
    end    
end

for n3 = 1:719
    a5(n3) = thetav5(n3) / t; % 计算滑块的加速度
end


% 3.位移,速度,加速度和曲柄滑块机构图形输出
figure(1);
n1=1:720;
n2=1:720;
n3=10:719;

subplot(2,2,1);         %绘制位移s5的图
plot(n1,s5(n1));
title('位移图');
xlabel('曲柄转角\theta_1/\circ');
grid on;
hold on;

subplot(2,2,2);         %绘制速度v5的图
plot(n2,v5(n2));
title('速度图');
xlabel('曲柄转角\theta_1/\circ');
grid on;
hold on;

subplot(2,2,3);         %绘制加速度a5的图
plot(n3,a5(n3));
title('加速度图');
xlabel('曲柄转角\theta_1/\circ');
grid on;
hold on;


subplot(2,2,4)          % 绘曲柄滑块机构图  
    xd1=65;
    % x(1), y(1) 是曲柄的旋转中心点
    x(1)=0;
    y(1)=0;
    % x(2), y(2) 计算得出的是曲柄末端的位置，这里使用了 70 度（转换为弧度）时的位置。
    x(2)=i1*cos(70*hd);
    y(2)=i1*sin(70*hd);
    % x(3), y(3) 表示滑块的位置，这里用的是当曲柄角度为 70 度时滑块的线位移 s3(70) 和固定的偏置 e
    x(3)=s3(70);
    y(3)=e;

    x(4)=i1+i2+50;
    y(4)=0;
    x(5)=0;
    y(5)=0;

    % 绘制滑块外框
    % 滑块左上角
    x(6)=x(3)-40;
    y(6)=y(3)+10;
    % 滑块右上角
    x(7)=x(3)+40;
    y(7)=y(3)+10;
    % 滑块右下角
    x(8)=x(3)+40;
    y(8)=y(3)-10;
    % 滑块左下角
    x(9)=x(3)-40;
    y(9)=y(3)-10;
    % 滑块左上角
    x(10)=x(3)-40;
    y(10)=y(3)+10;

    x(20)=xd1-10;
    y(20)=-50;
    x(21)=xd1-10;
    y(21)=50;
    x(22)=xd1+10;
    y(22)=-50;
    x(23)=xd1+10;
    y(23)=50;
    x(24)=xd1;
    y(24)=s5(70);

    % 绘制AB,BC等线
    i=1:5;
    plot(x(i), y(i));
    grid on;
    hold on;
    % 绘制滑块外框
    i=6:10;
    plot(x(i), y(i))
    title('曲柄滑块机构');
    grid on;
    hold on;

    i=20:21;
    plot(x(i), y(i),'-b')
    grid on;
    hold on;

    i=22:23;
    plot(x(i), y(i),'-b')
    grid on;
    hold on;

    xlabel('mm');
    ylabel('mm');
    axis([-50 400 -20 130]);
    plot(x(1), y(1),'o');
    plot(x(2), y(2),'o');
    plot(x(3), y(3),'o');
    plot(x(24), y(24), 'o', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 5);

    text(-10,-10,'A');
    text(x(2)-15,y(2)+10,'B');
    text(x(3),y(3)+20,'C');

% 4.曲柄滑块机构运动仿真
figure(2);
j = 0;
frames = [];  % 使用数组存储帧

for n1 = 1:5:360
    j = j + 1;
    clf;

    xd2=65;

    theta = n1 * hd;  % 计算一次，多次使用
    cos_theta = cos(theta);
    sin_theta = sin(theta);
    
    % 定义机构各点坐标
    x = [0, i1 * cos_theta, s3(n1), i1 + i2 + 50, 0];
    y = [0, i1 * sin_theta, e, 0, 0];
    
    % 添加滑块辅助图形的坐标
    x = [x, x(3) + [-20, 20, 20, -20, -20]];
    y = [y, y(3) + [11, 11, -11, -11, 11]];
    
    x = [x, 65];
    y = [y, s5(n1)];

    x(20)=xd2-10;
    y(20)=-50;
    x(21)=xd2-10;
    y(21)=50;
    x(22)=xd2+10;
    y(22)=-50;
    x(23)=xd2+10;
    y(23)=50;


    i=20:21;
    plot(x(i), y(i),'-b')
    grid on;
    hold on;

    i=22:23;
    plot(x(i), y(i),'-b')
    grid on;
    hold on;
    
    % 绘制曲柄、连杆和滑块
    plot(x(1:3), y(1:3), x(4:5), y(4:5), x(6:10), y(6:10));
    hold on;
    plot(x(1), y(1), 'o', x(2), y(2), 'o', x(3), y(3), 'o');
    plot(x(11), y(11), 'o', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 50);

    text(-10, -10, 'A');
    text(x(2) - 15, y(2) + 10, 'B');
    text(x(3), y(3) - 20, 'C');
    title('曲柄滑块机构');
    xlabel('mm');
    ylabel('mm');
    axis([-150, 450, -150, 150]);
    hold off;
    
    frames = [frames, getframe];  % 捕获帧
end

% 播放动画
movie(frames, 2);

end

%返回连杆和滑块的参数
function[theta2,s3,s5,omega2,v3,alpha2,a3]=sli_crank(theta1,omega1,alpha1,i1,i2,e,xd)

    % 1.计算连杆2的角位移theta2和滑块3的线位移s3
    theta2=asin((e-i1*sin(theta1))/i2);
    s3=i1*cos(theta1)+i2*cos(theta2);
    s5=(s3-xd)*sin(2*pi-theta2);

    % 2.计算连杆2的角速度theta2和滑块3的线位移s3
    A=[ i2*sin(theta2),1; -i2*cos(theta2),0];               % 机构从动件的位置参数矩阵
    B=[-i1*sin(theta1); i1*cos(theta1)];                    % 机构原动件的位置参数矩阵
    % omega1=10;  %主动件角速度
    omega=A\(omega1*B);                                     % 机构从动件的速度阵列
    omega2=omega(1);                                
    v3=omega(2);
    
    %计算连杆2的角速度和滑块3的加速度
    AT=[
        omega2*i2*cos(theta2),0;
        omega2*i2*sin(theta2),0            % At=dA/t
        ];
    BT=[
        -omega1*i1*cos(theta1);
        -omega1*i1*sin(theta1)
    ];                                     % Bt=dB/t
    % alpha1=0;   %主动件角加速度
    alpha=A\(-AT*omega+alpha1*B+omega1*BT);% 机构从动件的加速度列阵
    alpha2=alpha(1);
    a3=alpha(2);
end
