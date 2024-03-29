import 'package:dinojump03/components/ground.dart';
import 'package:dinojump03/components/meteor_component.dart';
import 'package:dinojump03/components/character.dart';
import 'package:dinojump03/utils/create_animation_by_limit.dart';
import 'package:dinojump03/consumibles/life.dart';
import 'package:dinojump03/consumibles/shield.dart';
import 'package:dinojump03/consumibles/win.dart';
import 'package:dinojump03/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'package:flame_audio/flame_audio.dart';

class PlayerComponent extends Character {
  Vector2 mapSize;
  MyGame game;

  bool blockPlayer = false;
  double blockPlayerTime = 2.0;
  double blockPlayerElapseTime = 0;

  bool inviciblePlayer = false;
  double inviciblePlayerTime = 8.0;
  double inviciblePlayerElapseTime = 0;

  final double terminalVelocity = 150;

  late SpriteAnimationTicker deadAnimationTicker;

  bool isMoving = false;
  late AudioPlayer audioPlayerRunning;

  PlayerComponent({required this.mapSize, required this.game}) : super() {
    anchor = Anchor.center;
    // anchor = Anchor.bottomLeft;
    debugMode = true;
    // scale = Vector2.all(.5);
  }

  int count = 0;

  @override
  Future<void>? onLoad() async {
    final spriteImage = await Flame.images.load('dinofull.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    // init animation
    deadAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08, loop: false);
    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08, loop: false);
    runAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    walkSlowAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .32);
    // end animation

    deadAnimationTicker = deadAnimation.createTicker();

    reset();

    body = RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4 - 20),
        position: Vector2(25, 10))
      ..collisionType = CollisionType.active
      ..debugMode = true
      ..debugColor = Colors.orange;

    FlameAudio.loop('step.wav').then((audioPlayer) {
      audioPlayerRunning = audioPlayer;
      audioPlayerRunning.stop();
    });

    // foot = RectangleHitbox(
    //     size: Vector2(50, 10),
    //     position: Vector2(55, spriteSheetHeight / 4 - 20))
    //   ..collisionType = CollisionType.passive;

    add(body);
    // add(foot);

    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (blockPlayer) {
      return true;
    }

    if (keysPressed.isEmpty) {
      animation = idleAnimation;
      movementType = MovementType.idle;
      velocity = Vector2.all(0);
      if (audioPlayerRunning.state == PlayerState.playing) {
        audioPlayerRunning.stop();
      }
    } else {
      if (!isMoving) {
        if (audioPlayerRunning.state == PlayerState.stopped) {
          audioPlayerRunning.resume();
        }
      }
    }

    if (inGround) {
      // RIGHT
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          // RUN
          movementType = MovementType.runright;
        } else {
          // WALKING
          movementType = MovementType.walkingright;
        }
      }
      // LEFT
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          // RUN
          movementType = MovementType.runleft;
        } else {
          // WALKING
          movementType = MovementType.walkingleft;
        }
      }
      // JUMP
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        movementType = MovementType.jump;
      }
    } else {
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        // RIGHT
        movementType = MovementType.jumpright;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        // LEFT
        movementType = MovementType.jumpleft;
      }
    }

    switch (movementType) {
      case MovementType.walkingright:
      case MovementType.runright:
        if (!right) flipHorizontally();
        right = true;

        if (!collisionXRight && position.x < mapSize.x) {
          animation = (movementType == MovementType.walkingright
              ? walkAnimation
              : runAnimation);
          velocity.x =
              jumpForceUp * (movementType == MovementType.walkingright ? 1 : 2);
          // position.x += jumpForceXY *
          //     (movementType == MovementType.walkingright ? 1 : 2);
        } else {
          animation = walkSlowAnimation;
        }
        break;
      case MovementType.walkingleft:
      case MovementType.runleft:
        if (right) flipHorizontally();
        right = false;

        if (!collisionXLeft && position.x > 0) {
          animation = (movementType == MovementType.walkingleft
              ? walkAnimation
              : runAnimation);
          // posX--;
          velocity.x =
              -jumpForceUp * (movementType == MovementType.walkingleft ? 1 : 2);
          // position.x -= jumpForceXY *
          //     (movementType == MovementType.walkingright ? 1 : 2);
        } else {
          animation = walkSlowAnimation;
        }

        break;
      case MovementType.jump:
      case MovementType.jumpright:
      case MovementType.jumpleft:
        if (inGround) {
          velocity.y = -jumpForceUp;
        }
        // position.y -= jumpForceXY;
        inGround = false;
        jumpUp = true;
        animation = jumpAnimation;
        if (movementType == MovementType.jumpright) {
          if (!right) flipHorizontally();
          right = true;

          if (!collisionXRight && position.x < mapSize.x) {
            velocity.x = jumpForceSide;
            // position.x += jumpForceXY;
          }
        } else if (movementType == MovementType.jumpleft) {
          if (right) flipHorizontally();
          right = false;

          if (!collisionXLeft && position.x > 0) {
            velocity.x = -jumpForceSide;
            // position.x -= jumpForceXY;
          }
        }

        break;
      case MovementType.idle:
        break;
    }

    return true;
  }

  @override
  void update(double dt) {
    if (blockPlayer) {
      if (blockPlayerElapseTime > blockPlayerTime) {
        blockPlayer = false;
        blockPlayerElapseTime = 0.0;
      }
      blockPlayerElapseTime += dt;
    }

    if (inviciblePlayer) {
      if (inviciblePlayerElapseTime > inviciblePlayerTime) {
        inviciblePlayer = false;
        inviciblePlayerElapseTime = 0.0;
      }
      inviciblePlayerElapseTime += dt;
    }

    if (!inGround) {
      // en el aire

      if (velocity.y * dt > 0 && jumpUp) {
        jumpUp = false;
      }

      velocity.y += gravity;
      //
    } else {
      velocity.y = 0;
    }

    velocity.y = velocity.y.clamp(-jumpForceUp, terminalVelocity);
    position += velocity * dt;

    deadAnimationTicker.update(dt);

    super.update(dt);
  }

  final Vector2 fromAbove = Vector2(0, -1);

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {
      if (points.first[0] <= 0.0) {
        // left
        collisionXLeft = true;
      } else if (points.first[0] >= mapSize.x) {
        // right
        collisionXRight = true;
      }
    }

    if (other is Ground && !jumpUp && !inGround) {
      if (points.length == 2) {
        // separation distance
        // punto Ground + Punto Player / 2
        final mid = (points.elementAt(0) + points.elementAt(1)) / 2;

        // distancia entre el centro de la colision y el centro del componente
        final collisionNormal = absoluteCenter - mid;

        // collisionNormal.length devuelve la magnitud del vector, se emplea para saber
        // cual es la longitud del vector es decir, cuanto mide
        // es decir, cuanto hay de un extremo al otro extremo
        // es decir de un punto al otro punto
        final separationDistance = (size.y / 2) - collisionNormal.length - 10;
        collisionNormal.normalize(); //convierte a un vector unitario

        // If collision normal is almost upwards,
        final v = fromAbove.dot(collisionNormal);
        print(v.toString());
        if (v > 0.9) {
          inGround = true;
          // Resolve collision by moving player along
          // collision normal by separation distance.
          // collisionNormal.scale(separationDistance);
          position += collisionNormal.scaled(separationDistance);
        }
      }

      // inGround = true;
      // position.y = other.position.y - size.y / 2 + 10;
      //velocity = Vector2.all(0);
    }

    if (other is Life && game.collisionMeteors > 0) {
      FlameAudio.play('explosion.wav');
      game.collisionMeteors--;
      game.overlays.remove('Statistics');
      game.overlays.add('Statistics');
      other.removeFromParent();
    }

    if (other is Shield) {
      inviciblePlayer = true;
      other.removeFromParent();
    }

    if (other is Win) {
      game.paused = true;
      game.overlays.add('GameOver');
    }

    if (game.collisionMeteors >= 3 && !inviciblePlayer) {
      reset(dead: true);
      FlameAudio.play('die.mp3');
    }

    super.onCollisionStart(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is ScreenHitbox) {
      collisionXLeft = collisionXRight = false;
    }

    if (other is Ground) {
      inGround = false;
      //jumpAnimation.reset();
    }

    if (other is MeteorComponent && !inviciblePlayer /*&& body.isColliding*/) {
      game.collisionMeteors++;
      game.overlays.remove('Statistics');
      game.overlays.add('Statistics');
    }

    super.onCollisionEnd(other);
  }

  void reset({bool dead = false}) async {
    game.overlays.remove('Statistics');
    game.overlays.add('Statistics');
    velocity = Vector2.all(0);
    game.paused = false;
    blockPlayer = true;
    inviciblePlayer = true;
    movementType = MovementType.idle;
    if (dead) {
      animation = deadAnimation;

      deadAnimationTicker = deadAnimation.createTicker();
      deadAnimationTicker.onFrame = (index) {
        // print("-----" + index.toString());
        if (deadAnimationTicker.isLastFrame) {
          animation = idleAnimation;
          position =
              Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
        }
      };

      deadAnimationTicker.onComplete = () {
        if (animation == deadAnimation) {
          animation = idleAnimation;
          position =
              Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
        }
      };
    } else {
      animation = idleAnimation;
      position = Vector2(spriteSheetWidth / 4, mapSize.y - spriteSheetHeight);
      size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);
    }
    game.collisionMeteors = 0;
    game.addConsumibles();

    //position = Vector2(spriteSheetWidth / 4, 0);
  }
}
