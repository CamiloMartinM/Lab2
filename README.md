<h1 align="center"; style="text-align:center;">Laboratorio 2 - Robótica de Desarrollo, Intro a ROS</h1>

## Robótica 
### Camilo A. Martín Moreno - Jorge A. Daza Rodríguez
### Universidad Nacional de Colombia

# Introducción

En este laboratorio se busca conocer los fundamentos de ROS y su conexión a la consola de Linux, luego de esto conocer algunos de sus comandos fundamentales y conectar nodos mediante Matlab, finalmente se usará Phyton para realizar una implementación de Turtlesim. 

# Conexión de ROS con Matlab

Para esta conexión es necesario iniciar la terminal de ubuntu con los siguientes comandos:

```
 - roscore
 - rosrun turtlesim node
```
Para esto se usa el siguiente código:

```
rosinit; %Conexion con nodo maestro
velPub = rospublisher('/turtle1/cmd_vel','geometry_msgs/Twist'); %Creaciaon publicador
velMsg = rosmessage(velPub); %Creacion de mensaje
velMsg.Linear.X = 1; %Valor del mensaje
send(velPub,velMsg); %Envio
pause(1)
```
Luego de esto obtenemos la posición de la tortuga en el momento de la ejecución:
```
subs=rossubscriber("/turtle1/pose","turtlesim/Pose"); %Suscribirse a la posición de la tortuga
PosX=subs.LatestMessage.X %Obtener y guardar la posición
```
Finalmente se cierra el nodo principal
```
%%Finalizar el nodo principal
rosshutdown
```

#ROS usando Phyton

Inicialmente vamos a obtener el valor de las teclas que oprima el usuario, para este caso se hará uso de W, A, S, D, Espacio y R. Las cuales tendrán las siguientes funciones: 



```
def getkey():
   fd = sys.stdin.fileno()
   old = termios.tcgetattr(fd)
   new = termios.tcgetattr(fd)
   new[3] = new[3] & ~TERMIOS.ICANON & ~TERMIOS.ECHO
   new[6][TERMIOS.VMIN] = 1
   new[6][TERMIOS.VTIME] = 0
   termios.tcsetattr(fd, TERMIOS.TCSANOW, new)
   c = None
   try:
       c = os.read(fd, 1)
   finally:
       termios.tcsetattr(fd, TERMIOS.TCSAFLUSH, old)
   return c
```

Luego de esto se establecerá el comando "R" con el cual la tortuga volverá a su posición inicial:
```
def teleport(x, y, ang):
    rospy.wait_for_service('/turtle1/teleport_absolute')
    try:
        teleportA = rospy.ServiceProxy('/turtle1/teleport_absolute', TeleportAbsolute)
        resp1 = teleportA(x, y, ang)
        print('Teleported to x: {}, y: {}, ang: {}'.format(str(x),str(y),str(ang)))
    except rospy.ServiceException as e:
        print(str(e))
```
Y finalmente se hará el giro de 180° con la tecla "Espacio":
```
def teleportRel(x,ang):
    rospy.wait_for_service('/turtle1/teleport_relative')
    try:
        teleportR = rospy.ServiceProxy('/turtle1/teleport_relative', TeleportRelative)
        resp1 = teleportR(x, ang)
        
    except rospy.ServiceException:
        pass
```
Finalmente se le indica al programa como emplear las demás teclas:

```
if __name__ == '__main__':
    pubVel(0,0,0.1)
    try:
        while(1):
            Tec=getkey()
            if Tec==b'w':
                pubVel(0.5,0,0.01)
            if Tec==b'a':
                pubVel(0,0.5,0.01)
            if Tec==b's':
                pubVel(-0.5,0,0.01)
            if Tec==b'd':
                pubVel(0,-0.5,0.01)
            if Tec==b' ':
                teleportRel(0,np.pi)
            if Tec==b'r':
                teleport(5.544445,5.544445,0)
            if Tec==b'\x1b':
                break                    
            

    except rospy.ROSInterruptException:
        pass 
```    

# Resultados

En el siguiente video se presentan algunos de los resultados del laboratorio:

[![Alt text](https://img.youtube.com/vi/2D7pDAbch9E/0.jpg)](https://www.youtube.com/embed/2D7pDAbch9E)

Figura 1: Demostración Laboratorio

Como se observa en el video el desarrollo del código en Phyton se dio de manera adecuada y se ven las diferentes trayectorias que tomó el programa.

# Conclusiones

Es importante aprender el funcionamiento ROS y su conexión mediante de nodos, entender este funcionamiento es útil en el área de la robótica.

Phyton ayuda a que la interacción entre el usuario y ROS se haga de manera más sencilla, mientras que Matlab es útil al momento de obtener información del sistema.
