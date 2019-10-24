from math import sin, cos, pi

rotations = 300
steps_per_rotation = 2000.0
h_per_rotation = 0.5
r = 50

for i in range(int(rotations * steps_per_rotation)):
    a = 2*pi * i/steps_per_rotation
    x = r * sin(a)
    y = r * cos(a)
    z = h_per_rotation * i / steps_per_rotation
    print('G1 X%.2f Y%.2f Z%.2f F5000' % (x, y, z))
