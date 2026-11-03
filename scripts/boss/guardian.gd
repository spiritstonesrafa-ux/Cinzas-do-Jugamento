class_name OathGuardian
extends CharacterBody2D
## One deterministic prototype pattern. Uses unchanged M1 receiver/M2 source contracts.
signal health_changed(current: int, maximum: int)
signal defeated
signal state_changed(value: int)
enum State { IDLE, INTRO, WAKE, PURSUIT, TELEGRAPH, ATTACK, HURT, PUNISH, DEFEATED, RESET }
@export_range(1,99,1) var max_health: int=10
@export var pursuit_speed: float=34.0
@export var intro_duration: float=0.9
@export var wake_duration: float=0.35
@export var telegraph_duration: float=0.8
@export var attack_duration: float=0.18
@export var punish_duration: float=1.1
var state: State=State.IDLE
var current_health: int=10
var target: KnightController
var facing: int=-1
var remaining: float=0
var flash: float=0
var awake: bool=false
var origin: Vector2
var resume_state: State=State.PURSUIT
var resume_time: float=0
@onready var attack_source: DamageSource=$AttackSource
@onready var visual: Node2D=$Visual
@onready var receiver: CollisionShape2D=$SwordReceiver/CollisionShape2D
func _ready() -> void:
 process_physics_priority=-2
 origin=position
 $SwordReceiver.hit_received.connect(receive_hit)
 reset_encounter()
func _set_state(value: State, duration: float=0) -> void:
 state=value
 remaining=duration
 velocity=Vector2.ZERO
 attack_source.set_active(value==State.ATTACK)
 if value==State.ATTACK:
  attack_source.set_direction(facing)
 state_changed.emit(state)
 visual.queue_redraw()
func reset_encounter() -> void:
 _set_state(State.RESET)
 position=origin
 facing=-1
 current_health=max_health
 awake=false
 flash=0
 receiver.set_deferred("disabled",false)
 health_changed.emit(current_health,max_health)
 _set_state(State.IDLE)
func begin(player: KnightController) -> void:
 target=player
 awake=true
 _set_state(State.INTRO,intro_duration)
func receive_hit() -> void:
 if not awake or state in [State.RESET,State.INTRO,State.WAKE,State.DEFEATED]:return
 current_health=maxi(0,current_health-1)
 flash=0.14
 health_changed.emit(current_health,max_health)
 if current_health==0:
  awake=false
  receiver.set_deferred("disabled",true)
  _set_state(State.DEFEATED)
  defeated.emit()
 elif state in [State.IDLE,State.PURSUIT,State.PUNISH]:
  resume_state=state
  resume_time=remaining
  _set_state(State.HURT,0.16)
 # Armor does not cancel a committed warning/swing; damage still counts.
func _physics_process(delta: float) -> void:
 flash=maxf(0,flash-delta)
 visual.scale.x=float(facing)
 visual.queue_redraw()
 if not awake:return
 if not is_instance_valid(target) or target.survival.is_dead:
  attack_source.set_active(false)
  velocity=Vector2.ZERO
  return
 remaining=maxf(0,remaining-delta)
 match state:
  State.INTRO:
   if remaining==0:_set_state(State.WAKE,wake_duration)
  State.WAKE:
   if remaining==0:_set_state(State.IDLE,0.35)
  State.IDLE:
   if remaining==0:_set_state(State.PURSUIT)
  State.PURSUIT:
   var distance: float=target.global_position.x-global_position.x
   facing=1 if distance>0 else -1
   if absf(distance)<=80:
    _set_state(State.TELEGRAPH,telegraph_duration)
   else:
    velocity.x=signf(distance)*pursuit_speed
    velocity.y=40
    move_and_slide()
    position.x=clampf(position.x,28,292)
  State.TELEGRAPH:
   if remaining==0:_set_state(State.ATTACK,attack_duration)
  State.ATTACK:
   if remaining==0:_set_state(State.PUNISH,punish_duration)
  State.PUNISH:
   if remaining==0:_set_state(State.PURSUIT)
  State.HURT:
   if remaining==0:_set_state(resume_state,resume_time)
