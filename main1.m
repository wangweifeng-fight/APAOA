%_______________________________________________________________________________________
%   The Adaptive Parallel Arithmetic Optimization Algorithm (APAOA) source codes
%
%  Developed in MATLAB R2019b
%
%  Authors: WeiFeng Wang
%
% Main paper:   The An Adaptive Parallel Arithmetic Optimization Algorithm for Robot Path Planning 
%_______________________________________________________________________________________

clear all
clc

Solution_no=160; %Number of search solutions 搜索解决方案的数量
N=40;
F_name='F3';    %Name of the test function F1-f23
M_Iter=500;    %Maximum number of iterations

%给出基准函数的测试信息，并调用函数
[LB,UB,Dim,fobj]=Get_F(F_name); %Give details of the underlying benchmark function
[Best_FF,Best_P,Conv_curve]=PAAOA(Solution_no,M_Iter,LB,UB,Dim,fobj); % Call the PAAOA （调用AOA）
% [Best_FF1,Best_P1,Conv_curve1]=ALO(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF2,Best_P2,Conv_curve2]=SSA(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF3,Best_P3,Conv_curve3]=SCA(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF4,Best_P4,Conv_curve4]=MFO(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF5,Best_P5,Conv_curve5]=MVO(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF6,Best_P6,Conv_curve6]=DA(N,M_Iter,LB,UB,Dim,fobj);
% [Best_FF7,Best_P7,Conv_curve7]=MTDE(N,M_Iter,LB,UB,Dim,fobj);
[Best_FF1,Best_P1,Conv_curve1]=AOA(N,M_Iter,LB,UB,Dim,fobj);
hold on
plot(Conv_curve,'--m','LineWidth',1.5);
plot(Conv_curve1,'-.k','LineWidth',1.5);
% % plot(Conv_curve2,'-y','LineWidth',1.5);
% plot(Conv_curve3,'--c','LineWidth',1.5);
% plot(Conv_curve4,'-.m','LineWidth',1.5);
% plot(Conv_curve5,'--','LineWidth',1.5);
% % plot(Conv_curve6,':g','LineWidth',1.5);
% % plot(Conv_curve7,':b','LineWidth',1.5);


% legend('MTDE','APAOA','ALO','SCA','MFO','MVO')
legend('APAOA','AOA')

grid on
title('F1:Convergence curve')
xlabel('Iteration');
ylabel('Fitness function value');
% print(gcf,'-depsc','f18.eps');


% display(['The best-obtained solution by Math Optimizer is : ', num2str(Best_P)]);
% display(['The best optimal value of the objective funciton found by Math Optimizer is : ', num2str(Best_FF)]);




