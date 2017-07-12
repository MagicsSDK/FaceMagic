precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;

const float tidu[9];
const float mat0[9];
const float mat1[9];
const float mat2[9];
const float mat3[9];

void main()
{
    float t_off_x = 0.0;
    float t_off_y = 0.0;
    
    float t_ditu_value = 0.0;
    float t_dir_0_ex = 0.0;
    float t_dir_1_ex = 0.0;
    float t_dir_2_ex = 0.0;
    float t_dir_3_ex = 0.0;
    
    float t_mat_ditu0[9];
    float t_mat_ditu1[9];
    float t_mat_ditu2[9];
    float t_mat_ditu3[9];
    
    for(int i=-1;i<=1;i++)
    {
        for(int j=-1;j<=1;j++)
        {
            vec2 t_new_texcoord = v_texcoord0 + vec2(i*t_off_x,j*t_off_y);
            vec4 color0 = texture2D(aTexture0,t_new_texcoord);
            float t_gray = 0.0; //rgba to gray
            int t_index = 3*(i+1)+(j+1);
            t_ditu_value = t_ditu_value + t_gray*tidu[t_index];
            //
            t_dir_0_ex = t_dir_0_ex + t_ditu_value*mat0[t_index];
            t_dir_1_ex = t_dir_1_ex + t_ditu_value*mat1[t_index];
            t_dir_2_ex = t_dir_2_ex + t_ditu_value*mat2[t_index];
            t_dir_3_ex = t_dir_3_ex + t_ditu_value*mat3[t_index];
        }
    }
    gl_FragColor.r = t_ditu_value;
    gl_FragColor.g = 0;
}
