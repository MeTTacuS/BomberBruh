extends Node

var players_to_start = 2

var spawn_positions = {0: null, 1: null, 2: null, 3:null}
var connected_ids = []

func _ready():
	get_tree().multiplayer.set_root_node(self)
	var network = NetworkedMultiplayerENet.new()
	network.create_server(4242, 4)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	multiplayer.connect("network_peer_packet", self, "_peer_packet_received")
	
	print("Server started")
	
func _process(delta):
	pass

func _peer_connected(id):
	print("User with id " + str(id) + " has connected to the server")
	
func _peer_disconnected(id):
	print("User with id " + str(id) + " has disconnected from the server")
	connected_ids.erase(id)
	var to_erase
	for pos in spawn_positions:
		print(pos)
		if (spawn_positions[pos] == id):
			spawn_positions[pos] = null
			break
	print(spawn_positions)
	send_user_disconnected(id)
			
func _peer_packet_received(id, packet):
	var data = packet.get_string_from_ascii()
	print("Received packet from id " + str(id) + " that contains data: " + data)
	if (data == "need_pos"):
		send_spawn_data(id)
	elif (data == "ready"):
		print("Player " + str(id) + " is ready")
		connected_ids.append(id)
		if (connected_ids.size() == players_to_start):
			send_start_game()
	elif (data[0] == "0"): # bomb has been placed
		var info = data.split(";")
		print(info[1])
		send_bomb_placed(info[1])
	elif (data[0] == "1"): # a player has moved
		var info = data.split(";")
		for _id in connected_ids:
			if (_id != int(info[2])):
				get_tree().multiplayer.send_bytes(("4;" + str(info[1]) + ";" + str(info[2])).to_ascii(), _id)
	
func send_spawn_data(id):
	for pos in spawn_positions:
		if (spawn_positions[pos] == null):
			spawn_positions[pos] = id
			get_tree().multiplayer.send_bytes(("0;" + (str(pos))).to_ascii(), id)
			send_new_user_connected(pos, id)
			return
		else:
			get_tree().multiplayer.send_bytes(("1;" + str(pos) + ";" + str(spawn_positions[pos])).to_ascii(), id)
	print("Failed to find a free spot for the player")

func send_start_game():
	get_tree().multiplayer.send_bytes("start".to_ascii())

func send_new_user_connected(pos, new_id):
	for id in connected_ids:
		get_tree().multiplayer.send_bytes(("1;" + str(pos) + ";" + str(new_id)).to_ascii(), id)
		
func send_user_disconnected(id):
	get_tree().multiplayer.send_bytes(("2;" + str(id)).to_ascii())

func send_bomb_placed(pos):
	get_tree().multiplayer.send_bytes(("3;" + str(pos)).to_ascii())

remote func i_moved(pos, id):
	for _id in connected_ids:
		if (_id != id):
			rpc_unreliable_id(int(_id), "update_position", pos)
#			get_tree().multiplayer.send_bytes(("4;" + str(pos) + ";" + str(id)).to_ascii(), _id)