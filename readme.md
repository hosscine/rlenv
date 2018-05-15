rlenv
====

This is r package of the environment for the reinforcement learning to explore a volcano.  
You can explore the environment with shiny application that is included in the package.

## Demo

## Install

```
devtools::install_github("hosscine/rlenv")
```

## Usage

To start GUI for manualy exploring:
```
library(rlenv)
startEnvironment()
```

To designe a reinforcement learning agent for the environment:
```
library(rlenv)
env <- volcanoExplorer$new()
```
## about "Volcano Explorer" class

A instance of the volcano explorer has methods below:
* `initialize()`
  * resets position and velocity of the agent
* `observeContinuous()`
  * observes state(position and velocity) continuously 
* `observeDiscrete()`
  * observes state(only position) discreately
* `actionContinuous(action.x, action.y, torque = 2)`
  * affects continuously 2D action to environment
* `actionContinuous(discrete.action, torque = 2)`
  * affects discretely 1D action to environment
  * discrete.action is required (0, 1, 2, 3, 4) to (stop, move up, move down, move left, move right), respectively
* `getReward()`
  * gets reward of current state
* `plot()`
  * plots the environment and the position of the agent

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[hosscine](https://github.com/hosscine)
