function visual_feat_interp = dg_visual_feature_interp(visual_feat, audio_feat)
% DG_VISUAL_FEATURE_INTERP Interpolate visual to match time of audio features.
%
%
%   DG_VISUAL_FEATURE_INTERP(VISUAL_FEAT, AUDIO_FEAT)
%   Return visual features matching the time dimension of the supplied audio
%   feature. The time dimension must be the first dimanesion of each feature
%   matrix. Using the spline interpolation method.
%
%   INPUTS:
%   VISUAL_FEAT the input visual features size: (vis_time_steps, feature_len)
%   AUDIO_FEAT the input audio features size: (aud_time_steps, feature_len)
%
%   OUTPUT:
%   VISUAL_FEAT_INTERP visual features that match the time of the audio features.

video_timesteps = length(visual_feat);
audio_timesteps = length(audio_feat);

visual_x = 1:video_timesteps;
query_x = linspace(1, video_timesteps, audio_timesteps);

visual_feat_interp = interp1(visual_x, visual_feat, query_x, 'spline');
% EOF
