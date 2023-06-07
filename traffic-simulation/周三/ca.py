SPEED_MAX = 6
BRAKE_P = 0.2
GAP_MAX = 10000
LANE_CHANGE_P = 0.05

from random import random, choice

class Car:
    def __init__(self, position, speed=0):
        self.position = position
        self.speed = speed
        self.lane_change_target = None

    def sense(self, lane, idx):
        #获取front_gap
        if idx >= len(lane.cars) - 1:
            self.front_gap = GAP_MAX
        else:
            front_car = lane.cars[idx + 1]
            self.front_gap = front_car.position - self.position - 1

    def plan(self):
        self.speed = min(self.speed, self.front_gap)

        if self.speed < min(self.front_gap, SPEED_MAX):
            self.speed += 1

        if self.speed > 0 and random() < BRAKE_P:
            self.speed -= 1

    def act(self):
        self.position += self.speed

    def lc_sense(self, road, lane_idx, idx):
        if not self.lane_change_target:
            return
        
        target_lane = road.lanes[self.lane_change_target]
        gaps = [car.position - self.position - 1 for car in target_lane.cars]


    def lc_plan():
        pass

    def lc_act():
        pass

    def update_lane_change_target(self, road, lane_idx, idx):
        if random() < LANE_CHANGE_P:
            targets = []
            if lane_idx + 1 < len(road.lanes):
                targets.append(lane_idx + 1)
            if lane_idx - 1 >= 0:
                targets.append(lane_idx - 1)

            self.lane_change_target = choice(targets)

class Lane:
    def __init__(self, length=30):
        self.length = length
        self.cars = []

    def add_car(self, position, speed):
        car = Car(position, speed)
        self.cars.append(car)
    
    def sense(self):
        for idx, car in enumerate(self.cars):
            car.sense(self, idx)
        
    def plan(self):
        for car in self.cars:
            car.plan()

    def act(self):
        for car in self.cars:
            car.act()

    def lc_sense(self):
        for idx, car in enumerate(self.cars):
            car.sense(self, idx)
        
    def lc_plan(self):
        for car in self.cars:
            car.plan()

    def lc_act(self):
        for car in self.cars:
            car.act()

    def get_state(self):
        state = [" "] * self.length
        for car in self.cars:
            state[car.position] = "o"

        return "".join(state)

class Road:
    def __init__(self, length=30, num_lane=2):
        self.length = length
        self.lanes = [Lane(length) for i in range(num_lane)]

    def sense(self):
        for lane in self.lanes:
            lane.sense()

    def plan(self):
        for lane in self.lanes:
            lane.plan()

    def act(self):
        for lane in self.lanes:
            lane.act()

    def lc_sense(self):
        for lane_idx, lane in enumerate(self.lanes):
            for idx, car in enumerate(lane.cars):
                lane.lc_sense(self, lane_idx, idx)

    def lc_plan(self):
        for lane_idx, lane in enumerate(self.lanes):
            for idx, car in enumerate(lane.cars):
                lane.lc_plan(self, lane_idx, idx)

    def lc_act(self):
        pass

    def update_lane_change_target(self):
        for lane_idx, lane in enumerate(self.lanes):
            for idx, car in enumerate(lane.cars):
                car.update_lane_change_target(self, lane_idx, idx)

    def get_state(self):
        sideline = "-" * self.length
        
        state = ""
        state += sideline
        state += "\n"

        for lane in self.lanes:
            state += lane.get_state()
            state += "\n"
        state += sideline
        state += "\n"

        return state

class World:
    def __init__(self):
        self.roads = []

    def add_road(self, length, num_lane):
        road = Road(length, num_lane)
        self.roads.append(road)

    #def add_lane(self, length):
    #    lane = Lane(length)
    #   self.lanes.append(lane)

    def sense(self):
        for road in self.roads:
            road.sense()

    def plan(self):
        for road in self.roads:
            road.plan()

    def act(self):
        for road in self.roads:
            road.act()

    def lc_sense(self):
        for road in self.roads:
            road.lc_sense()

    def lc_plan(self):
        for road in self.roads:
            road.lc_plan()

    def lc_act(self):
        for road in self.roads:
            road.lc_act()

    def step(self):
        # Car following
        self.sense()
        self.plan()
        self.act()

        # Lane changing
        self.lc_sense()
        self.lc_plan()
        self.lc_act()

        # Remove cars beyond lane length
        for road in self.roads:
            for lane in road.lanes:
                lane.cars = [car for car in lane.cars if car.position < lane.length]

world = World()
world.add_road(30, 3)
world.roads[0].lanes[0].add_car(0, 3)
world.roads[0].lanes[2].add_car(5, 0)

for i in range(10):
    print(world.roads[0].get_state())
    world.step()

