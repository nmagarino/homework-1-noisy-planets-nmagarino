#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;

in vec4 fs_CameraPos;
in vec4 fs_Pos;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.
uniform highp int u_Time;
uniform int u_Cells;

void main()
{
    float time = float(u_Time);
    // Material base color (before shading)
        vec4 diffuseColor = u_Color;
        
        // Calcs for Blinn-phong
        vec4 view = fs_Pos * vec4(5.0, 0.0, 3.0, 1.0);

        vec4 H = (fs_LightVec + view) / 2.0;

        float specHighlight = max(pow(dot(normalize(H), normalize(fs_Nor)), 50.0), 0.0);

        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
        // Avoid negative lighting values
         diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        float alpha = diffuseColor.a;

        // Compute final shaded color

        // Base Green
        out_Col = vec4((vec3(0.69,1.0,0.5625) * lightIntensity), alpha);
        out_Col = vec4(out_Col.xyz * 1.2 * distance(fs_Pos, vec4(0.0,0.0,0.0,1.0)), alpha);
        

        // Water
        if(distance(fs_Pos, vec4(0.0,0.0,0.0,0.0)) < 1.415) {
            
            // Worley noise
            float numCells = float(u_Cells);

            float minimum = 1.f;
            vec2 minPoint;

            vec2 cellUV = fs_Pos.xy * numCells;
            vec2 cellID = floor(cellUV);
            vec2 localCellUV = fract(cellUV);

            for(float i = -1.0; i <= 1.0; i++) {
                for(float j = -1.0; j <= 1.0; j++) {

                    vec2 random = fract(sin(vec2(dot(cellID + vec2(i, j), vec2(127.1, 311.7)),
                                        dot(cellID + vec2(i, j), vec2(269.5, 183.3))))
                                        * 43758.5453);

                    random = 0.5 + 0.5 * sin((time / 5.0) + 6.2831 * random);

                    float dist = length(vec2(i, j) + random - localCellUV);

                    if(dist < minimum) {
                        minimum = dist;
                        minPoint = vec2(i, j);
                    }
                }
            }




                    out_Col = vec4((vec3(0.0,0.1,abs(((cellID + minPoint)/ float(numCells)) * 1.00001)) * lightIntensity) + specHighlight, alpha);
                    
                    if(dot(fs_LightVec, fs_Nor) < 0.0) {
                        out_Col = vec4((vec3(0.0,0.1,abs(((cellID + minPoint)/ float(numCells)) * 1.00001)) * lightIntensity), alpha);
                    }
                }
}
