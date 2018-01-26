Nicholas Magarino
PennKey: nmaga

For my implementation of Worley Noise I mainly consulted The Book of Shaders.
The implementation of Perlin Noise I used in my terrain generation was based from an implementation from Stefan Gustavson.
I also took some inspiration from the Implicit Procedural Planet Generation by Eli Meckler & Ryan Patton.

For my terrain I used several passes of Perlin Noise, and adjusted the original sphere's position in the direction of the normal based on the noise value returned.  The displacement technically goes in and out deeper into the sphere, but I constrained the displacement to only go as far as a sphere of about radius 1.  The water effects were made with an implementation of Worley Noise, where colors were sampled from the original shading of the sphere.  The water is shaded with Blinn-Phong reflection (built up from the original Lambert shader).  
