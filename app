import os
import random
from moviepy.editor import VideoFileClip, CompositeVideoClip, concatenate_videoclips, vfx

def create_random_video(output_index, output_name):
    clips_folder = "D:/ffmpeg stuff/clips"
    outro_clip = "D:/ffmpeg stuff/outro_clip/outro_clip.mov"

    all_main_clips = [clip for clip in os.listdir(clips_folder) if "V2" in clip and clip.endswith('.mov')]
    all_secondary_clips = [clip for clip in os.listdir(clips_folder) if "V1" in clip and clip.endswith('.mov')]

    if len(all_main_clips) < 1 or len(all_secondary_clips) < 1:
        print("Error: There are not enough main or secondary clips in the 'clips' folder.")
        return

    main_clip = random.choice(all_main_clips)
    secondary_clip = random.choice(all_secondary_clips)

    main_clip_path = os.path.join(clips_folder, main_clip)
    secondary_clip_path = os.path.join(clips_folder, secondary_clip)

    main_clip_video = VideoFileClip(main_clip_path)
    secondary_clip_video = VideoFileClip(secondary_clip_path)

    # Ensure both clips have the same duration
    min_duration = min(main_clip_video.duration, secondary_clip_video.duration)
    main_clip_video = main_clip_video.subclip(0, min_duration)
    secondary_clip_video = secondary_clip_video.subclip(0, min_duration)

    # Resize and stretch the secondary clip vertically while maintaining its original width
    secondary_clip_resized = secondary_clip_video.resize((1080, 1920)).fx(vfx.resize, width=1080, height=1920)

    # Position main clip in the center
    main_clip_position = ((1080 - main_clip_video.h) // 2, (1920 - main_clip_video.w) // 2)

    # Overlay the resized secondary clip on the main clip
    final_clip = CompositeVideoClip([secondary_clip_resized.set_position('center'),
                                     main_clip_video.set_position(main_clip_position)])

    outro = VideoFileClip(outro_clip)
    final_clip = concatenate_videoclips([final_clip, outro])

    # Write the final video to the specified output path
    output_filename = f"{output_name}_final{output_index}.mp4"
    output_path = os.path.join("D:/ffmpeg stuff/output_path", output_filename)
    final_clip.write_videofile(output_path, codec='libx264', audio_codec='aac', temp_audiofile='temp-audio.m4a', remove_temp=True)

if __name__ == "__main__":
    output_name = input("Enter the output name: ")

    for i in range(1, 2):  # Generate 5 videos
        create_random_video(i, output_name)
