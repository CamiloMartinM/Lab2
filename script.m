%%
rosinit; %Conexi ́on con nodo maestro
%%
velPub = rospublisher('/turtle1/cmd_vel','geometry_msgs/Twist'); %Creaciaon publicador
velMsg = rosmessage(velPub); %Creaci ́on de mensaje
%%
velMsg.Linear.X = 1; %Valor del mensaje
send(velPub,velMsg); %Envio

a=rossubscriber("/turtle1/pose","turtlesim/Pose"); %Suscribirse a la posición de la tortuga
PosX=a.LatestMessage.X %Obtener y guardar la posición

%%Finalizar el nodo principal
rosshutdown