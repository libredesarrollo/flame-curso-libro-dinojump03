import 'dart:ui';

import 'package:dinojump03/components/ground.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'package:dinojump03/components/character.dart';
import 'package:dinojump03/utils/create_animation_by_limit.dart';



class PlayerComponent extends Character {

  Vector2 mapSize;

  PlayerComponent({ required this.mapSize }): super(){
    anchor = Anchor.center;
    debugMode = true;
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
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);
    runAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    walkSlowAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .32);
    // end animation

    animation = idleAnimation;

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    position = Vector2(centerX, centerY);

    add(RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4),
        position: Vector2(25, 0)));

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      animation = idleAnimation;
    }

    //***X */
    // correr
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      playerSpeed = 1500;

      if (!right) flipHorizontally();
      right = true;

      if (!collisionXRight) {
        animation = runAnimation;
        posX++;
      } else {
        animation = walkSlowAnimation;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      playerSpeed = 500;
      if (!right) flipHorizontally();
      right = true;

      if (!collisionXRight) {
        animation = walkAnimation;
        posX++;
      } else {
        animation = walkSlowAnimation;
      }
    }

    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      playerSpeed = 1500;

      if (right) flipHorizontally();
      right = false;

      if (!collisionXLeft) {
        animation = runAnimation;
        posX--;
      } else {
        animation = walkSlowAnimation;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      playerSpeed = 500;

      if (right) flipHorizontally();
      right = false;

      if (!collisionXLeft) {
        animation = walkAnimation;
        posX--;
      } else {
        animation = walkSlowAnimation;
      }
    }

    //***Y */
    if ((keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
            keysPressed.contains(LogicalKeyboardKey.keyW)) &&
        inGround) {
      animation = walkAnimation;
      velocity.y = -jumpForce;
      position.y -= 15;
      inGround = false;
      animation = jumpAnimation;
    }
    // if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
    //     keysPressed.contains(LogicalKeyboardKey.keyS)) {
    //   animation = walkAnimation;

    //   posY++;
    // }

    return true;
  }

  @override
  void update(double dt) {
    position.x += playerSpeed * dt * posX;
    position.y += playerSpeed * dt * posY;
    posX = 0;
    posY = 0;

    if (!inGround) { // en el aire
      velocity.y += gravity;
      position.y += velocity.y * dt;
    } 

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {

    if (other is ScreenHitbox) {
      if (points.first[0] <= 0.0) {
        // left
        collisionXLeft = true;
      } else if (points.first[0] >= mapSize.x
          //MediaQueryData.fromWindow(window).size.height
          
          ) {
        // left
        collisionXRight = true;
      }
    }

    if(other is Ground){
      inGround = true;
    }

    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionXLeft = collisionXRight = false;
    super.onCollisionEnd(other);
  }
}
