---
layout: post
title: 'Twisty Puzzles: 4x4 Pyramorphix (Megamorphix) Center Parity'
date: 2022-01-12 17:19:15.000000000 -08:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Twisty Puzzles
tags:
- puzzles
meta:
  _wpcom_is_markdown: '1'
  _thumbnail_id: '1707'
  _last_editor_used_jetpack: block-editor
  timeline_notification: '1642007958'
  _publicize_job_id: '67603445270'
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: "/2022/01/12/twisty-puzzles-4x4-pyramorphix-megamorphix-center-parity/"
excerpt: Solving the 4x4 megamorphix twisty puzzle's rotated center parity
---
<!-- wp:paragraph -->

Yo_u can find a lot of great videos showing you how to fix megamorphix parities. I prefer to learn by reading and following pictures, so I hope this post helps some people. There are other methods to solve a megamorphix, but this post shows the solutions that I use._

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Previously I wrote about how I figured out [how to solve the 3x3 pyramorphix](https://productionwithscissors.run/2021/05/06/twisty-puzzles-3x3-pyramorphix-solution/) (note: I wrote this post before I learned the [CFOP](https://www.speedsolving.com/wiki/index.php/CFOP_method)[method](https://www.speedsolving.com/wiki/index.php/CFOP_method) for cubes; you can use either!) and the [5x5 gigamorphix](https://productionwithscissors.run/2021/06/10/twisty-puzzles-5x5-pyramorphix-gigamorphix-solution/). You can use that 5x5 guide to solve a most parity issues for a megamorphix, but with the 4x4 puzzle and other morphix puzzles with an even number of layers, you may encounter one parity not found in the puzzles with an odd number of layers.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

On these even layer puzzles, the center block on the last layer can be rotated 90° with respect to its edges and corners. We don't see this issue with standard 4x4x4 speed cubes because those centers don't have any visible difference if a center gets rotated.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

In the megamorphix, this parity often isn't obvious until you have tried to orient and permutate the last layer. If the corners and edges are in place, the center will be rotated. If the edges along with the center block, two corners will be swapped.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## 1. Solve the first 3 layers

<!-- /wp:heading -->

<!-- wp:list {"ordered":true} -->

1. Group the centers and the edge groups. You can solve edge groups ("dedges") using the standard 4x4x4 speed cube methods. When solving the center groups, be sure to orient each center's pieces. You can use the method from [my 5x5x5 post.](https://productionwithscissors.run/2021/06/10/twisty-puzzles-5x5-pyramorphix-gigamorphix-solution/)

<!-- /wp:list -->

<!-- wp:paragraph -->

You can use the [CFOP method](https://www.speedsolving.com/wiki/index.php/CFOP_method) or whatever method you want to solve the first 3 layers.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## 2. Start solving the last layer

<!-- /wp:heading -->

<!-- wp:paragraph -->

To orient and permute the edges and corners on the last layer, you can adopt the CFOP method. Correct a single flipped edge using a [4x4x4 dedge algorithm](https://www.speedsolving.com/wiki/index.php/4x4x4_parity_algorithms#One_dedge_flip).

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Next, pick the solution that matches your puzzle's current configuration.

<!-- /wp:paragraph -->

<!-- wp:group -->

<!-- wp:columns -->
<!-- wp:column {"width":"66.66%"} -->
<!-- wp:paragraph -->

If you have solved the puzzle without a parity, you can stop now!

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- wp:column {"width":"33.33%"} -->

<!-- wp:image {"id":1712,"sizeSlug":"large","linkDestination":"none"} -->
![Photo of a solved megamorphix puzzle]({{ site.baseurl }}/assets/images/2022/01/20220111_143344_edited.png?w=736)  

_This megamorphix puzzle appears to be solved except for two corners on the last layer which are swapped_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- /wp:group -->

<!-- wp:heading -->

## 3. Re-align edges

<!-- /wp:heading -->

<!-- wp:columns -->

<!-- wp:column {"width":"66.66%"} -->
<!-- wp:paragraph -->

_If the edges and corners of your puzzle's top layer are solved, you can skip to Step 4._

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

If your puzzle looks like this, although any two corners can be swapped on the last layer (instead of three possible corners, which we can fix using a [U algorithm](https://www.speedsolving.com/wiki/index.php/PLL#U_Permutation_:_a)), use these algorithms to move the edge pieces around the center into their final configuration.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

**Note: U algorithms will rotate some centers by 180** °. Don't worry, we will fix these at the end using an OLL algorithm. You can also cancel out the rotated centers by using two Ua permutations instead of one Ub permutation, or two Ub permutations instead of one Ua.

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- wp:column {"width":"33.33%"} -->

<!-- wp:image {"id":1707,"sizeSlug":"large","linkDestination":"none"} -->
![Two corners are swapped in otherwise solved 4x4 megamorphix]({{ site.baseurl }}/assets/images/2022/01/20220111_141531_edited.png?w=736)  

_This megamorphix puzzle appears to be solved except for two corners on the last layer which are swapped_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:columns -->

<!-- wp:column -->
<!-- wp:paragraph -->

Use a U permutation to move the edges in a quarter .

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Two of your edges should be flipped out like bird wings (the red edges in the example).

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- wp:column -->

<!-- wp:image {"id":1716,"sizeSlug":"large","linkDestination":"none"} -->
![Photo of partially solved megamorphix with last layer edges permuted 90 degrees around the center block]({{ site.baseurl }}/assets/images/2022/01/20220111_141936_edited.png)  

_First we rotate the edges around the last layer center block by 90 degrees_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:columns -->

<!-- wp:column -->
<!-- wp:image {"id":1715,"sizeSlug":"large","linkDestination":"none"} -->
![4x4 megamorphix with edges rotated 90 degrees around the last layer center]({{ site.baseurl }}/assets/images/2022/01/20220111_142122_edited.png)  

_Then we flip the pair of edges across from the other two, properly oriented edges around the last layer center block_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- wp:column -->

<!-- wp:paragraph -->

Holding one of the second set of edges in UF and the other in UR, use the following algorithm to flip them into wings:

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

R B (M' U' M' U' M' U M U' M U' M U2) B' R'

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The top layer of your puzzle should now look something like this, although the corners may be in different positions.

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:heading -->

## 4. Rotate last center 90°

<!-- /wp:heading -->

<!-- wp:columns -->

<!-- wp:column -->
<!-- wp:paragraph -->

Now we need to rotate the center blocks so they fit the edges around them.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

The easiest way to do this is to pick one of the solid center pieces and use commutators to rotate the whole block in 3 steps. The example here assumes the block needs to be rotated +90°.

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- wp:column -->

<!-- wp:image {"id":1714,"sizeSlug":"large","linkDestination":"none"} -->
![4x4 megamorphix with center pieces out of place]({{ site.baseurl }}/assets/images/2022/01/20220111_142834_edited.png?w=736)  

_Permuting the rotated center to the correct orientation on a 4x4 megamorphix puzzle_

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:paragraph -->

**Note:** Lower case letter in this notation mean move the inner slice only instead of the outer slice.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

**Always hold the "last" layer face as F. Always use the same color piece for each commatation.** (The pictured example uses the red piece.) You will need to repeat the commutator algorithm 3 times. Be careful not to break up edge groups. Try to rotate the F and U faces back after each commutation to keep the first 3 layers solved.

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### To move the center clockwise

<!-- /wp:heading -->

<!-- wp:paragraph -->

Match the solid pieces in positions UBR and UFR.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Algorithm: r U' l' U r' U' l U

<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### To move the center counterclockwise

<!-- /wp:heading -->

<!-- wp:paragraph -->

Match solid pieces in UBL and UFL.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

Algorithm: l' U r U' l U r' U'

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

In this example, the center needed to be rotated clockwise. I matched the red piece in the centers each tim. The picture shows the progress after the first commutation.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## 5. Solve corners on last layer

<!-- /wp:heading -->

<!-- wp:columns -->

<!-- wp:column {"width":"33.33%"} -->
<!-- wp:paragraph -->

If you didn't solve the corners with the edges before rotation the center, do that now.

<!-- /wp:paragraph -->

<!-- wp:paragraph -->

After that, your puzzle should be solved!

<!-- /wp:paragraph -->

<!-- /wp:column -->

<!-- wp:column {"width":"66.66%"} -->

<!-- wp:image {"id":1713,"sizeSlug":"large","linkDestination":"none"} -->
![Megamorphix with first 3 layers solved, and with top layer edges and center solved. Corners still need to be permutated.]({{ site.baseurl }}/assets/images/2022/01/20220111_143141_edited.png?w=736)  

_In this example, we just need to use the A* permutations twice to position the corners. We may also need to flip one or two of the 3-color corners._

<!-- /wp:image -->

<!-- /wp:column -->

<!-- /wp:columns -->

<!-- wp:heading -->

## References

<!-- /wp:heading -->

<!-- wp:list -->

- https://www.reddit.com/r/Cubers/comments/3y7q36/megamorphix\_help\_please/
- https://www.speedsolving.com/wiki/index.php/4x4x4\_parity\_algorithms
- https://www.speedsolving.com/wiki/index.php/CFOP\_method
- https://www.speedsolving.com/wiki/index.php/Commutator
- https://www.speedsolving.com/wiki/index.php/NxNxN\_Notation
- https://www.speedsolving.com/wiki/index.php/Reduction\_Method
- https://youtu.be/8KzCzqmHk88

<!-- /wp:list -->

