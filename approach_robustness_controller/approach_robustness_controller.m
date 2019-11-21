function [sys,x0,str,ts] = approach_robustness_controller(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % 调用初始化子函数
  case 1,
    sys=[];
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %计算输出子函数
  case 4,
    sys=[];   %计算下一仿真时刻子函数
  case 9,
    sys=[];    %终止仿真子函数
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %初始化子函数

sizes = simsizes;

sizes.NumContStates  = 0;  %连续状态变量个数
sizes.NumDiscStates  = 0;  %离散状态变量个数
sizes.NumOutputs     = 3;  %输出变量个数
sizes.NumInputs      = 3;   %输入变量个数
sizes.DirFeedthrough = 1;   %输入信号是否在输出子函数中出现
sizes.NumSampleTimes = 0;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];   %初始值
str = [];   
ts  = [];   %[0 0]用于连续系统，[-1 0]表示继承其前的采样时间设置
simStateCompliance = 'UnknownSimState';

function sys=mdlOutputs(t,x,u)   %计算输出子函数
thd = u(1);
dthd = cos(t);
ddthd = -sin(t);
th = u(2);
dth = u(3);

e = thd - th;
de = dthd - dth;
c = 15;
s = c*e + de;

fx = 25*dth;
dU = 10;
dL = -10;

epc = 0.5;
k = 10;
b = 133;

ut = 1/b*(epc*sign(s) + k*s + c*(dthd - dth) + ddthd + fx - (dU + dL)/2 + (dU - dL)/2*sign(s));

sys(1) = ut;
sys(2) = e;
sys(3) = de;

