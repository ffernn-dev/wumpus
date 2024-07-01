@tool
extends Node

var phi = (1 + sqrt(5)) / 2  # The golden ratio
var vertices = [
	Vector3(-1, 1, -1),
	Vector3(0, phi, -1/phi),
	Vector3(0, phi, 1/phi),
	Vector3(-1, 1, 1),
	Vector3(-phi, 1/phi, 0),
	Vector3(-phi, -1/phi, 0),
	Vector3(-1, -1, -1),
	Vector3(-1/phi, 0, -phi),
	Vector3(1/phi, 0, -phi),
	Vector3(1, 1, -1),
	Vector3(phi, 1/phi, 0),
	Vector3(1, 1, 1),
	Vector3(1/phi, 0, phi),
	Vector3(-1/phi, 0, phi),
	Vector3(-1, -1, 1),
	Vector3(0, -phi, 1/phi),
	Vector3(0, -phi, -1/phi),
	Vector3(1, -1, -1),
	Vector3(phi, -1/phi, 0),
	Vector3(1, -1, 1),
]

var edges = [
	[0, 1], [1, 2], [2, 3], [3, 4], [4, 0],
	[4, 5], [5, 6], [6, 7], [7, 0],
	[7, 8], [8, 9], [9, 1],
	[9, 10], [10, 11], [11, 2],
	[11, 12], [12, 13], [13, 3],
	[13, 14], [14, 5],
	[15, 16], [16, 17], [17, 18], [18, 19], [19, 15],
	[14, 15], [6, 16], [8, 17], [10, 18], [12, 19]
]
