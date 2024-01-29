#this script defines the size of the gameplay and the cells
extends Node

const GRID_SIZE := Vector2(1024, 512) #1024x512 gameplay
const CELL_SIZE := Vector2(64, 64) #each square in the grid is 64x64

const CELLS_AMOUNT := Vector2(GRID_SIZE.x / CELL_SIZE.x, GRID_SIZE.y / CELL_SIZE.y) #calculate cells in the grid, for drawing the grid can be deleted later
