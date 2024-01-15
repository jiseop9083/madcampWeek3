// game_screen.dart
import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

import 'package:app/map/Level.dart';
import 'package:app/Components/Player.dart';
//import 'package:app/util/AudioManager.dart';

class SnowManGame extends LeapGame with TapCallbacks {
  SnowManGame({
    required super.tileSize,
  });

  late final CameraComponent cam;
  Player player = Player();

  //AudioManager audioManager = AudioManager();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // Default the camera size to the bounds of the Tiled map.
    final world = Level(player: player);
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: tileSize * 40,
      height: tileSize * 23,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]); //player
    // audioManager.initialize();
    // audioManager.playMainBGM();
    return super.onLoad();
  }

  // DO TO : move this code to util/interface.dart
  // DO TO: 터치 후 이동하면 취소 안됨
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      if (touchPoint.y <= size.y / 2) {
        // jump
        player.jump();
      } else if (touchPoint.y > size.y / 2 && touchPoint.x > size.x / 2) {
        // right
        player.setMoveDirection(1);
      } else {
        //left
        player.setMoveDirection(-1);
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (event.canvasPosition.y > size.y / 2) {
      // jump
      player.setMoveDirection(0);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.update(dt);
  }
}
