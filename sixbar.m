function main
% 1.������֪����
clear;
i1=60;
i2=120;
xd=65;
e=0;
hd = pi/180; %һ�ȶ�Ӧ�Ļ���
du=180/pi;  %һ���ȶ�Ӧ�Ķ���
omega1=10;  %���������ٶ�
alpha1=0;   %�������Ǽ��ٶ�
t=hd/10;    %�������˶���λԲ�ܽǶ�1���Ӧ��ʱ��

% 2.ʹ���Ӻ�����������������λ�ã��ٶȣ����ٶȡ�
% ͨ��һ��ѭ������������ÿһ����λ�ã��� 0 �� 720 �ȣ���ʹ�� sli_crank ��������ÿ���Ƕ������˺ͻ���Ĳ�����
for n1 = 1:721
    theta1(n1) = (n1 - 1) * hd;          
    [theta2(n1), s3(n1), s5(n1), omega2(n1), v3(n1), alpha2(n1), a3(n1)] = sli_crank(theta1(n1), omega1, alpha1, i1, i2, e, xd);
    if n1 == 1
        s5_prev = s5(n1); % ����ǰһ��λ�õĻ���λ��
    else
        thetas5(n1) = s5(n1) - s5_prev; % ������������λ�õĻ���λ��
        s5_prev = s5(n1); % ����ǰһ��λ�õĻ���λ��
    end
end

for n2 = 1:720
    v5(n2) = thetas5(n2) / t; 
    if n2 == 1
        v5_prev = v5(n2); % ����ǰһ��λ�õĻ����ٶ�
    else
        thetav5(n2) = v5(n2) - v5_prev; % �������������ٶȵı仯��
        v5_prev = v5(n2); % ����ǰһ��λ�õĻ����ٶ�
    end    
end

for n3 = 1:719
    a5(n3) = thetav5(n3) / t; % ���㻬��ļ��ٶ�
end


% 3.λ��,�ٶ�,���ٶȺ������������ͼ�����
figure(1);
n1=1:720;
n2=1:720;
n3=10:719;

subplot(2,2,1);         %����λ��s5��ͼ
plot(n1,s5(n1));
title('λ��ͼ');
xlabel('����ת��\theta_1/\circ');
grid on;
hold on;

subplot(2,2,2);         %�����ٶ�v5��ͼ
plot(n2,v5(n2));
title('�ٶ�ͼ');
xlabel('����ת��\theta_1/\circ');
grid on;
hold on;

subplot(2,2,3);         %���Ƽ��ٶ�a5��ͼ
plot(n3,a5(n3));
title('���ٶ�ͼ');
xlabel('����ת��\theta_1/\circ');
grid on;
hold on;


subplot(2,2,4)          % �������������ͼ  
    xd1=65;
    % x(1), y(1) ����������ת���ĵ�
    x(1)=0;
    y(1)=0;
    % x(2), y(2) ����ó���������ĩ�˵�λ�ã�����ʹ���� 70 �ȣ�ת��Ϊ���ȣ�ʱ��λ�á�
    x(2)=i1*cos(70*hd);
    y(2)=i1*sin(70*hd);
    % x(3), y(3) ��ʾ�����λ�ã������õ��ǵ������Ƕ�Ϊ 70 ��ʱ�������λ�� s3(70) �͹̶���ƫ�� e
    x(3)=s3(70);
    y(3)=e;

    x(4)=i1+i2+50;
    y(4)=0;
    x(5)=0;
    y(5)=0;

    % ���ƻ������
    % �������Ͻ�
    x(6)=x(3)-40;
    y(6)=y(3)+10;
    % �������Ͻ�
    x(7)=x(3)+40;
    y(7)=y(3)+10;
    % �������½�
    x(8)=x(3)+40;
    y(8)=y(3)-10;
    % �������½�
    x(9)=x(3)-40;
    y(9)=y(3)-10;
    % �������Ͻ�
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

    % ����AB,BC����
    i=1:5;
    plot(x(i), y(i));
    grid on;
    hold on;
    % ���ƻ������
    i=6:10;
    plot(x(i), y(i))
    title('�����������');
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

% 4.������������˶�����
figure(2);
j = 0;
frames = [];  % ʹ������洢֡

for n1 = 1:5:360
    j = j + 1;
    clf;

    xd2=65;

    theta = n1 * hd;  % ����һ�Σ����ʹ��
    cos_theta = cos(theta);
    sin_theta = sin(theta);
    
    % ���������������
    x = [0, i1 * cos_theta, s3(n1), i1 + i2 + 50, 0];
    y = [0, i1 * sin_theta, e, 0, 0];
    
    % ��ӻ��鸨��ͼ�ε�����
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
    
    % �������������˺ͻ���
    plot(x(1:3), y(1:3), x(4:5), y(4:5), x(6:10), y(6:10));
    hold on;
    plot(x(1), y(1), 'o', x(2), y(2), 'o', x(3), y(3), 'o');
    plot(x(11), y(11), 'o', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 50);

    text(-10, -10, 'A');
    text(x(2) - 15, y(2) + 10, 'B');
    text(x(3), y(3) - 20, 'C');
    title('�����������');
    xlabel('mm');
    ylabel('mm');
    axis([-150, 450, -150, 150]);
    hold off;
    
    frames = [frames, getframe];  % ����֡
end

% ���Ŷ���
movie(frames, 2);

end

%�������˺ͻ���Ĳ���
function[theta2,s3,s5,omega2,v3,alpha2,a3]=sli_crank(theta1,omega1,alpha1,i1,i2,e,xd)

    % 1.��������2�Ľ�λ��theta2�ͻ���3����λ��s3
    theta2=asin((e-i1*sin(theta1))/i2);
    s3=i1*cos(theta1)+i2*cos(theta2);
    s5=(s3-xd)*sin(2*pi-theta2);

    % 2.��������2�Ľ��ٶ�theta2�ͻ���3����λ��s3
    A=[ i2*sin(theta2),1; -i2*cos(theta2),0];               % �����Ӷ�����λ�ò�������
    B=[-i1*sin(theta1); i1*cos(theta1)];                    % ����ԭ������λ�ò�������
    % omega1=10;  %���������ٶ�
    omega=A\(omega1*B);                                     % �����Ӷ������ٶ�����
    omega2=omega(1);                                
    v3=omega(2);
    
    %��������2�Ľ��ٶȺͻ���3�ļ��ٶ�
    AT=[
        omega2*i2*cos(theta2),0;
        omega2*i2*sin(theta2),0            % At=dA/t
        ];
    BT=[
        -omega1*i1*cos(theta1);
        -omega1*i1*sin(theta1)
    ];                                     % Bt=dB/t
    % alpha1=0;   %�������Ǽ��ٶ�
    alpha=A\(-AT*omega+alpha1*B+omega1*BT);% �����Ӷ����ļ��ٶ�����
    alpha2=alpha(1);
    a3=alpha(2);
end
