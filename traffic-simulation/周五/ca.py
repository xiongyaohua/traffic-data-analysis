from random import random

GAP_MAX = 1000
SPEED_MAX = 7
P = 0.1
SAFE_GAP_FRONT = 1
SAFE_GAP_BACK = 2

class Car:
    def __init__(self, position, speed, lc_target=0):
        self.position = position
        self.speed = speed
        self.lc_target = lc_target
        self.lc_safe = False

    def cf_sense(self, lane, idx):
        if idx == len(lane.cars) - 1:
            self.gap = GAP_MAX
        else:
            front_car = lane.cars[idx+1]
            self.gap = front_car.position - self.position - 1

    def cf_plan(self):
        if self.speed < SPEED_MAX:
            self.speed += 1

        self.speed = min(self.speed, self.gap)

        if self.speed > 0 and random() < P:
            self.speed -= 1

    def cf_act(self):
        self.position += self.speed

    def lc_sense(self, target_lane):
        for car in target_lane.cars:
            if car.position == self.position:
                self.front_gap = -1
                self.back_gap = -1
                return
            
        front_gaps = [car.position - self.position - 1 for car in target_lane.cars]
        self.front_gap = min([gap for gap in front_gaps if gap >= 0], default=GAP_MAX)
        back_gaps = [self.position - car.position - 1 for car in target_lane.cars]
        self.back_gap = min([gap for gap in back_gaps if gap >= 0], default=GAP_MAX)

    def lc_plan(self):
        if self.front_gap >= SAFE_GAP_FRONT and self.back_gap >= SAFE_GAP_BACK:
            self.lc_safe = True
        else:
            self.lc_safe = False

    def lc_act(self):
        pass

class Lane:
    def __init__(self, length):
        self.length = length
        self.cars = []

    def add_car(self, car):
        self.cars.append(car)
        self.cars.sort(key=lambda car: car.position)

    def cf_sense(self):
        for idx, car in enumerate(self.cars):
            car.cf_sense(self, idx)

    def cf_plan(self):
        for car in self.cars:
            car.cf_plan()

    def cf_act(self):
        for car in self.cars:
            car.cf_act()

        self.cars = [car for car in self.cars if car.position < self.length]

    def get_state(self):
        state = [" "] * self.length
        for car in self.cars:
            state[car.position] = "o"

        return "".join(state)
    
class Road:
    def __init__(self, length, num_lane):
        self.length = length
        self.lanes = [Lane(30) for i in range(num_lane)]

    def add_car(self, car, idx_lane):
        self.lanes[idx_lane].add_car(car)

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

    def cf_sense(self):
        for lane in self.lanes:
            lane.cf_sense()

    def cf_plan(self):
        for lane in self.lanes:
            lane.cf_plan()

    def cf_act(self):
        for lane in self.lanes:
            lane.cf_act()

    def lc_sense(self):
        for lane_idx, lane in enumerate(self.lanes):
            for car in lane.cars:
                target_idx = lane_idx + car.lc_target
                target_lane = self.lanes[target_idx]
                car.lc_sense(target_lane)

    def lc_plan(self):
        for lane in self.lanes:
            for car in lane.cars:
                car.lc_plan()

    def lc_act(self):
        for lane_idx, lane in enumerate(self.lanes):
            for car in lane.cars:
                if car.lc_target != 0 and car.lc_safe:
                    target_idx = lane_idx + car.lc_target
                    target_lane = self.lanes[target_idx]
                    lane.cars.remove(car)
                    target_lane.add_car(car)
        

class World:
    def __init__(self):
        self.time = 0.0
        self.roads = []

    def add_road(self, length, num_lane):
        road = Road(length, num_lane)
        self.roads.append(road)

    def step(self, dt=1.0):
        for road in self.roads:
            road.cf_sense()
        
        for road in self.roads:
            road.cf_plan()
        
        for road in self.roads:
            road.cf_act()

        for road in self.roads:
            road.lc_sense()
        
        for road in self.roads:
            road.lc_plan()
        
        for road in self.roads:
            road.lc_act()

    def get_state(self):
        return [road.get_state() for road in self.roads]


world = World()
world.add_road(40, 2)

world.roads[0].add_car(Car(0, 3), 0)
world.roads[0].add_car(Car(6, 5, -1), 1)
world.roads[0].add_car(Car(15, 0), 0)


for i in range(10):
    print(world.get_state()[0])
    world.step()


