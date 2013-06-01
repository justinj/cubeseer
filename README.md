CubeSeer
--------

CubeSeer is a Ruby cube image generation library,
similar to [VisualCube](http://cube.crider.co.uk/visualcube.php).

Right now only a top view is possible,
which works well for PLL diagrams.

Possible Eventual Features
--------------------------

* Cube rendering
  * Ignoring certain stickers (gray)
  * 3D view
  * Rounded side stickers, like VisualCube has

* Cube representing
  * Create from a case rather than an alg (just invert the alg first)
  * Create by explicitly setting each sticker

Cube Representation
-------------------

The representation of a cube as implemented in `cube.rb` works as follows:

A cube can currently be created only by calling the method `Cube.algorithm`,
which takes a size and an alg to perform on a solved cube.

Once you have that cube,
you can perform queries on it of the form "ABC:XYZ"

Where ABC and XYZ are corners with a specific orientation.

This will return an array of arrays representing the stickers on that face.

For example, "UBL:UFR" will return from the top left corner of U to the bottom left corner.

On a solved cube this will be

```ruby
[[:U, :U, :U],
 [:U, :U, :U],
 [:U, :U, :U]]   
```