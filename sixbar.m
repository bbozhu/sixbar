function main
%������֪����
clear;
i1=100;
i2=300;
e=0;
hd = pi/180; %һ�ȶ�Ӧ�Ļ���
du=180/pi;  %һ���ȶ�Ӧ�Ķ���
omega1=10;  %���������ٶ�
alpha1=0;   %�������Ǽ��ٶ�

%ʹ���Ӻ�����������������λ�ã��ٶȣ����ٶȡ�
for n1=1:721
    theta1(n1)=(n1-1)*hd;          %
    %���ú�������������Ƴ�����]
    [theta2(n1),xc(n1),omega2(n1),vc(n1),alpha2(n1),ac(n1)]=sli_crank(theta1(n1),omega1,alpha1,i1,i2,e);
end
%ͼ�������ʼ������
figure(1);
n1=1:720;

%����λ�Ƶ�ͼ
subplot(2,2,1);
[ax,h1,h2]=plotyy(theta1*du,theta2*du,theta1*du,xc);
set(get(ax(1), 'ylabel'), 'String', '���˽�λ��/\circ');
set(get(ax(2), 'ylabel'), 'String', '����λ��/mm');
title('λ��ͼ');
xlabel('����ת��\theta_1/\circ');
grid on;
hold on;

% set(get(gca, 'PropertyName'), 'PropertyName', PropertyValue);

%�ٶ�
subplot(2,2,2);
[ax,h1,h2]=plotyy(theta1*du,omega2,theta1*du,vc)
title('�ٶ�ͼ');
xlabel('����ת��\theta_1/\circ')
ylabel('���˽��ٶ�/rad\cdots^{-1}')
set(get(ax(2), 'ylabel'), 'String', '�����ٶ�/mm\cdots^{-1}')
grid on;
hold on;

%���ٶ�
subplot(2,2,3);
[ax,h1,h2]=plotyy(theta1*du,alpha2,theta1*du,ac)
title('���ٶ�ͼ');
xlabel('����ת��\theta_1/\circ')
ylabel('���˽Ǽ��ٶ�/rad\cdots^{-2}')
set(get(ax(2), 'ylabel'), 'String', '������ٶ�/mm\cdots^{-2}')

grid on;
%����λ��ͼ
subplot(2,2,4)
    x(1)=0;
    y(1)=0;
    x(2)=i1*cos(70*hd);
    y(2)=i1*sin(70*hd);
    x(3)=xc(70);
    y(3)=e;
    x(4)=i1+i2+50;
    y(4)=0;
    x(5)=0;
    y(5)=0;
    x(6)=x(3)-40;
    y(6)=y(3)+10;
    x(7)=x(3)+40;
    y(7)=y(3)+10;
    x(8)=x(3)+40;
    y(8)=y(3)-10;
    x(9)=x(3)-40;
    y(9)=y(3)-10;
    x(10)=x(3)-40;
    y(10)=y(3)+10;
i=1:5;
plot(x(i), y(i))
grid on;
hold on;
i=6:10;
plot(x(i), y(i))
title('�����������');
grid on;
hold on;
xlabel('mm');
ylabel('mm');
axis([-50 400 -20 130]);
plot(x(1), y(1),'o')
plot(x(2), y(2),'o')
plot(x(3), y(3),'o')
    text(-10,-10,'A')
    text(x(2)-15,y(2)+10,'B')
    text(x(3),y(3)+20,'C')
    gtext('����')
    gtext('����')
    gtext('����')
grid on;
hold on;

%�˶����棬��Ӱ����
figure(2);
j=0;
for n1 = 1:5:360
    j=j+1;
    clf;
    x(1)=0;
    y(1)=0;
    x(2)=i1*cos(n1*hd);
    y(2)=i1*sin(n1*hd);
    x(3)=xc(n1);
    y(3)=e;
    x(4)=i1+i2+50;
    y(4)=0;
    x(5)=0;
    y(5)=0;
    x(6)=x(3)-40;
    y(6)=y(3)+10;
    x(7)=x(3)+40;
    y(7)=y(3)+10;
    x(8)=x(3)+40;
    y(8)=y(3)-10;
    x(9)=x(3)-40;
    y(9)=y(3)-10;
    x(10)=x(3)-40;
    y(10)=y(3)+10;
    i=1:3;
    plot(x(i), y(i));
    grid on;
    hold on;
    i=4:5;
    plot(x(i), y(i))
    i=6:10;
    plot(x(i), y(i))
    plot(x(1),y(1),'o')
    plot(x(2),y(2),'o')
    plot(x(3),y(3),'o')
    text(-10,-10,'A')
    text(x(2)-15,y(2)+10,'B')
    text(x(3),y(3)-20,'C')
    title('�����������');
    xlabel('mm');
    ylabel('mm');
    axis([-150 450 -150 150]);
    m(j)=getframe;

end
movie(m,2);
end

%�������˺ͻ���Ĳ���
function[theta2,xc,omega2,vc,alpha2,ac]=sli_crank(theta1,omega1,alpha1,i1,i2,e)

    %�������˵Ľ�λ��theta2��xc
    theta2=asin((e-i1*sin(theta1))/i2);
    xc=i1*cos(theta1)+i2*cos(theta2);

    %�������˺ͻ���Ĳ���������lazy
    A=[ i2*sin(theta2),1;
        -i2*cos(theta2),0
        ];
    B=[-i1*sin(theta1);
    i1*cos(theta1)];
    omega=A\(omega1*B);
    omega2=omega(1);
    vc=omega(2);
    
    %�������˺ͻ���ļ��ٶ�
    AT=[
        omega2*i2*cos(theta2),0;
        omega2*i2*sin(theta2),0
        ];
    BT=[
        -omega1*i1*cos(theta1);
        -omega1*i1*sin(theta1)
    ];
    alpha=A\(-AT*omega+alpha1*B+omega1*BT);%��Ӧ����������
    alpha2=alpha(1);
    ac=alpha(2);
end
%�����õĺ���д���ˣ������ڵ�һ�¡�

%����д�꣬����һ�¡�