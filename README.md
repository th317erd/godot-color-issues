This shows the color channel issues I am having with `sample2D` uniform textures coming from SubViewports.

I have the following setup:
1. MainViewport is a SubViewport that contains the scene. In my game, this is used to downsample the game scene so that the first-pass shader runs more efficiently (on less fragments).
2. SubViewport is a SubViewport that contains MainViewport + a camera with a Quad in front of it to render the output of MainViewport. In my game, this runs the second-pass shader, that uses information rendered by the first shader to do further rendering.
3. Finally, at the root of the scene is a PrimaryCamera with a Quad in front of it that renders the final result of the second-pass shader, the output of SubViewport.
4. There is a failure at the second-pass shader (SubViewport) because the colors have changed... so the encoding I am doing in the first-pass shader has become messed up.
5. I have enabled HDR 2D _EVERYWHERE_, and have attempted every other trick I could possibly find online. Nothing appears to help.

You can download and run this exmpample immediately to see the issue.

1. first_process_shader.ghshader is where the colors from the scene are all encoded into a single channel (the red channel)
2. second_process_shader.gdshader is where the colors are decoded from the red channel, and rendered onto the scene.

Please help!
