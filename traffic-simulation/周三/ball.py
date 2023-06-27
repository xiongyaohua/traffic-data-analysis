GRAVITY = -9.8
BALL_RADIUS = 0.1

import matplotlib.pyplot as plt

class Ball:
    def __init__(self, height, speed=0.0):
        self.height = height
        self.speed = speed

    def step(self, dt):
        self.speed += dt * GRAVITY
        self.height += dt * self.speed

        if self.height <= BALL_RADIUS:
            self.height = BALL_RADIUS
            self.speed *= -0.9

class World:
    def __init__(self):
        self.balls = [Ball(2)]
        self.time = 0.0

    def step(self, dt):
        for ball in self.balls:
            ball.step(dt)
        self.time += dt

    def get_state(self):
        return (self.time, self.balls[0].height)

def simulate():
    world = World()
    dt = 0.1

    states = []
    for i in range(100):
        world.step(dt)
        states.append(world.get_state())

    return states

states = simulate()
times, heights = zip(*states)
plt.plot(times, heights)
plt.show()
