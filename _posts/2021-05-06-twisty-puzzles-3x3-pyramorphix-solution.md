---
layout: post
title: 'Twisty Puzzles: 3x3 Pyramorphix Solution'
date: 2021-05-06 05:40:44.000000000 -07:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Twisty Puzzles
tags:
- not-tech
- puzzles
meta:
  _wpcom_is_markdown: '1'
  _last_editor_used_jetpack: block-editor
  timeline_notification: '1620279647'
  _publicize_job_id: '58022671446'
  _edit_last: '108235749'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2021/05/06/twisty-puzzles-3x3-pyramorphix-solution/"
excerpt: Solving the 3x3 pyramorphix twisty puzzle
excerpt_image: /assets/images/2021/05/20210505_170641.gif
---
<!-- wp:image {"align":"center","id":1598,"sizeSlug":"large","linkDestination":"none"} -->

![Animated gif of a tuxedo cat ignoring a hand rotating a solved kilomorphix puzzle in front of her face]({{ site.baseurl }}/assets/images/2021/05/20210505_170641.gif?w=344)  

_George was unimpressed the first time I solved the puzzle_

<!-- /wp:image -->

<!-- wp:paragraph -->

I've recently taken up twisty puzzles for a pandemic hobby. I've been tinkering quite a bit with the 3x3 pyramorphix, so I thought I'd write up the way I finally figured out how to solve it reliably. My method won't win any speed solving contests but it works.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Many write-ups of the puzzle's mechanics already exist, so I will just quickly recap:

<!-- /wp:paragraph -->

<!-- wp:columns -->

<!-- wp:column {"width":"50%"} -->
<!-- wp:list -->
- The puzzle has many similarities to a standard 3x3x3 cube, including some of the same basic algorithms
- Those things that look like edges are actually faces 
- Those things that look like edge pieces with two colors are actually centers
- Those things that look like faces are not faces
- There are two kinds of corners: the flat triangles with one color and the pyramids with three different colors. They can all be moved to any corner position
- Center orientation matters, unlike standard cubes
- Centers aren't fixed relative to each other, unlike standard cubes
- Edges can be rotated 180° so they stick out of the plane of the surface like fan blades

<!-- /wp:list -->

<!-- /wp:column -->

<!-- wp:column {"width":"50%"} -->

<!-- wp:image {"id":1601,"sizeSlug":"large","linkDestination":"none"} -->
![Marked up photo of a logical side of the pyramorphix puzzle labeling the pieces]({{ site.baseurl }}/assets/images/2021/05/parts.jpg?w=736)  

_Ceci n'est pas un cube?_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:heading -->

## Solution Steps

<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->

1. Position centers
2. Position edges
3. Position corners
4. Rotate (align) twisted edges
5. Rotate (align) tri-color corners
6. Rotate (align) flipped centers

<!-- /wp:list -->

<!-- wp:heading {"level":3} -->

### Position Centers

<!-- /wp:heading -->

<!-- wp:paragraph -->

I don't have algorithms for this step.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

I get my centers into the right relative position first. For example, the solved puzzle has a flat blue "side" around the flat blue triangle center piece. That means 3 centers which are half-red will circle around the flat red center piece.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The corner opposite ("down" face) the flat triangle side will be the blue/green/yellow corner. It will be surrounded by the blue/yellow, yellow/green, and green/blue centers.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

This solution works to keep the centers in the same correct position after each sequence and center pieces' corners "pointing" in the correct direction.

<!-- /wp:paragraph -->

<!-- wp:columns -->

<!-- wp:column {"width":"50%"} -->
<!-- wp:image {"id":1608,"sizeSlug":"large","linkDestination":"none"} -->
![Photo of a scrambled pyramorphix twisty puzzle showing three red triangle sides of center pieces]({{ site.baseurl }}/assets/images/2021/05/pxl_20210503_182444772-01.jpeg?w=1022)  

_The red sides of three center pieces correctly placed and oriented. In the completed puzzle, the green corner in the center will be replaced with the red flat corner piece. Some edge pieces are flipped._

<!-- /wp:image -->

<!-- /wp:column -->

<!-- wp:column {"width":"50%"} -->

<!-- wp:image {"id":1610,"sizeSlug":"large","linkDestination":"none"} -->
![Photo of an unsolved twisty puzzle showing three center-type pieces, blue/green, green/yellow, and yellow/blue, forming a triangle and pointing up in the same direction]({{ site.baseurl }}/assets/images/2021/05/pxl_20210503_182455250-01.jpeg?w=1024)  

_On the opposite side, the blue/green, green/yellow, and yellow/blue corner pieces are oriented correctly. In the completed puzzle, the flat blue center piece will be replaced with the blue/green/yellow pyramidal corner piece. Some edge pieces are flipped._

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:paragraph -->

**Important** : After each sequence, make sure the color alignment of the center is NOT flipped 90°. I found an algo for flipping centers 180° non-destructively, but none for rotating a single center 90° without changing other pieces.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Position Edges

<!-- /wp:heading -->

<!-- wp:paragraph -->

You can position these around the centers intuitively, or you can use the algorithms in the table below to permute edges (in groups of 3). (Hint: they're PLL algorithms used for rotating 3 edges for 3x3 cubes). These algorithms flip the centers 180° and swap corners, so we apply them first.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Note: Don't worry if an edge is flipped.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Position Corners

<!-- /wp:heading -->

<!-- wp:paragraph -->

See the algorithms below, which permute corners around a shared center in groups of three. You may need to apply them several times.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Note: Don't worry if a corner's colors are rotated.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Rotate Twisted Edges

<!-- /wp:heading -->

<!-- wp:paragraph -->

Twisted edges come in pairs (unless I'm missing something or someone modified your puzzle). The algorithm below expects a pair of twisted edges to be across a shared center, so you may have to perform one or two moves to pair them, perform the algorithm, then revert the temporary moves.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Rotate Corners

<!-- /wp:heading -->

<!-- wp:paragraph -->

One algorithm will rotate both the corner in position 3 120° clockwise AND the corner in position 9 120° counterclockwise at the same time. Since one of these corners will be a solid flat corner if the pieces are all in their correct positions, this should not cause any problems.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Rotate Centers

<!-- /wp:heading -->

<!-- wp:paragraph -->

If you've kept the centers in the correct positions and aligned, you may have some which are flipped, but none that are rotated only 90°. You can use the algorithm below to unflip each center that is rotated 180°.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Algorithms

<!-- /wp:heading -->

<!-- wp:paragraph -->

I'll use standard [NxNxN notation](https://www.speedsolving.com/wiki/index.php/NxNxN_Notation) and all the algorithms below use the "up" face for the working face, using the piece position numbering shown above, where the "front" face is the one sharing pieces 7,8,9. For example, to use an algorithm that rotates the corner #3 in place, you'll hold the puzzle so the corner you want to modify is in position 3 on the "up" face.

<!-- /wp:paragraph -->

<!-- wp:image {"id":1604,"sizeSlug":"large","linkDestination":"none"} -->

![Marked up photo of the face of a pyramorphix showing the included pieces, which are numbered 1 (top-left), 2 (top center), 3 (top right), 4 (center left), 5 (center), 6 (center right), 7 (bottom left), 8 (bottom center), 9 (bottom right)]({{ site.baseurl }}/assets/images/2021/05/pxl_20210505_235323492-1.jpg?w=1024)  

_Position numbers for the "up" face pieces used in the table below_

<!-- /wp:image -->

<!-- wp:table -->

|
| |
 Change | Algorithm | Side effects || Permute 3 Edges (4,6,8) ↻ | F2 U L R' F2 L' R U F2 | Rotates "up" center 180° |

Swaps corners

| Permute 3 Edges (4,6,8) ↺ | F2 U' L R' F2 L' R U' F2 | Rotates "up" center 180° |

Swaps corners on "up" face

| Permute 3 Corners (1,3,9) ↻ | U' L' U R U' L U R' | None |
| Permute 3 Corners (1,3,7) ↺ | U R U' L' U R' U' L | None |
| Rotate Edges 2 & 8 180° | M' U' M' U' M' U2 M U' M U' M U2 |

Alternative (fixed centers):  
LR' F' LR' D' LR' B2  
L'R D' L'R F' L'R U2

 None - rotates edges in place || Rotate Corner 3 120° ↺ | L' U' L U' L' U2 L R U R' U R U2 R' | Also rotates corner 9 120° ↻ |
| Rotate Corner 9 120° ↻ | L' U' L U' L' U2 L R U R' U R U2 R' | Also rotates corner 3 120° ↺ |
| Rotate Center 5 180° | U R L U2 R' L' U R L U2 R' L' | None |

_Algorithms used in this method_

<!-- /wp:table -->

<!-- wp:heading -->

## References

<!-- /wp:heading -->

<!-- wp:list -->

- [http://www.multiwingspan.co.uk/puzzle.php?solution=mastermorphix](http://www.multiwingspan.co.uk/puzzle.php?solution=mastermorphix)
- [https://www.speedsolving.com/wiki/index.php/Master\_Pyramorphix](https://www.speedsolving.com/wiki/index.php/Master_Pyramorphix)

<!-- /wp:list -->

