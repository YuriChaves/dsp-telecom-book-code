%compare with bilinear without pre-warping
snip_systems_sampling %define Hs and Hz
subplot(311);
numPeriods = 2; %half of the number of periods to be plotted
WradsMax=2*pi*Fs*numPeriods;
N=5000; %grid points
f=linspace(-numPeriods*Fs,numPeriods*Fs,N); %in Hz
w=2*pi*f; %in rad/s
w=[w -20 20]; w=sort(w); %make sure 20 rad/s is in w
H=freqs(Hs_num, Hs_den, w); %H(s)
indicesMax = find(abs(H)==max(abs(H)));
plotHandler=plot(w,20*log10(abs(H)));
xlabel('\omega_a (rad/s)'), ylabel('|H_s(\omega_a)|')
makedatatip(plotHandler, indicesMax(2));
%axis tight
subplot(312);
%trick freqz to obtain w in rad
w=linspace(-numPeriods*2*pi,numPeriods*2*pi,N); %in rad
H=freqz(Hz_num, Hz_den,w,2*pi);
indicesMax = find(abs(H)==max(abs(H)));
plotHandler2=plot(w,20*log10(abs(H)));
xlabel('\Omega (rad)'), ylabel('|H_z(e^{j \Omega})|')
makedatatip(plotHandler2, indicesMax(2));
%axis tight
axis([-12.45 12.45 -120 30])
ak_add3dots
subplot(313);
H=freqz(Hz_num, Hz_den,f,Fs);
indicesMax = find(abs(H)==max(abs(H)));
plotHandler3=plot(2*pi*f,20*log10(abs(H)));
xlabel('\omega_d (rad/s)'), ylabel('|H_z(e^{j \omega_d t_s})|')
makedatatip(plotHandler3, indicesMax(2));
%axis tight
axis([-124.5 124.5 -120 30])
ak_add3dots
writeEPS('bilinear_freq_responses','font12Only')

%% Figure to show D/C conversion
clf
subplot(211);
H=freqz(Hz_num, Hz_den,w,2*pi);
indicesMax = find(abs(H)==max(abs(H)));
plotHandler2=plot(w,20*log10(abs(H)));
xlabel('\Omega (rad)'), ylabel('|X(e^{j \Omega})|')
myaxis=axis;
axis([myaxis(1) myaxis(2) -100 myaxis(4)])
makedatatip(plotHandler2, indicesMax(2));
%axis tight
ak_add3dots
subplot(212);
H=freqz(Hz_num, Hz_den,f,Fs);
indicesMax = find(abs(H)==max(abs(H)));
plotHandler3=plot(2*pi*f,20*log10(abs(H)));
xlabel('\omega (rad/s)'), ylabel('|X_s(\omega)|')
makedatatip(plotHandler3, indicesMax(2));
myaxis=axis;
axis([myaxis(1) myaxis(2) -100 myaxis(4)])
%axis tight
ak_add3dots
writeEPS('dc_conversion','font12Only')

%compare with bilinear with pre-warping
clf
snip_systems_sampling %define Hs and Hz
%new redefine [Hz_num, Hz_den] using pre-warping:
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs, 20/(2*pi));
subplot(211);
numPeriods = 2; %half of the number of periods to be plotted
WradsMax=2*pi*Fs*numPeriods;
N=1000; %grid points
f=linspace(-numPeriods*Fs,numPeriods*Fs,N); %in Hz
w=2*pi*f; %in rad/s
w=[w -20 20]; w=sort(w); %make sure 20 rad/s is in w
H=freqs(Hs_num, Hs_den, w); %H(s)
indicesMax = find(abs(H)==max(abs(H)));
plotHandler=plot(w,20*log10(abs(H)));
xlabel('\omega_a (rad/s)'), ylabel('|H_s(j \omega_a)|')
makedatatip(plotHandler, indicesMax(2));
subplot(212);
H=freqz(Hz_num, Hz_den,f,Fs);
indicesMax = find(abs(H)==max(abs(H)));
plotHandler3=plot(2*pi*f,20*log10(abs(H)));
xlabel('\omega_d (rad/s)'), ylabel('|H_z(e^{j \omega_d t_s})|')
%axis tight
makedatatip(plotHandler3, indicesMax(2));
axis tight
%axis([-124.5 124.5 -120 30])
ak_add3dots
writeEPS('bilinear_responses_prewarped','font12Only')

%%%%%%%%%%%%%%%%another figure
clf
Fs=100; %sampling frequency
Ts=1/Fs; %sampling period
smallAngle=0.1; %avoid tangent going to +/- infinity

%show mapping
wd=linspace(-pi+smallAngle,pi-smallAngle,1000);
wa=2/Ts*tan(wd/2);
plotHandler=plot(wd,wa)
makedatatip(plotHandler, 900);
xlabel('\Omega (rad)');
ylabel('\omega (rad/s)');
hold on

%subtract 2 pi
wa=2/Ts*tan( (wd-2*pi) /2);
plotHandler2=plot(wd-2*pi,wa,'r')
makedatatip(plotHandler2, 900);

%add 2 pi
wa=2/Ts*tan( (wd+2*pi) /2);
grid
plotHandler3=plot(wd+2*pi,wa,'k')
makedatatip(plotHandler3, 900);
ak_add3dots

writeEPS('bilinear_freqs')

clf
numGridPoints=800;
zlim=2.5;
%Fs_values=[0.1 1 4 10];
%Fs_values=[1 10 100 1000];
Fs_values=[1 3 5 7];
%%%%%%next
if 0
    %this was the example from \figl{s_mag}
    a=1; b=-2; c=-1+1j*2; %choose poles and zeros
    Hs_num=poly(a);
    Hs_den=poly([b c conj(c)]);
else %but now I am going to use this that looks like a differentiator
    Hs_num=101*poly([1 1]);
    Hs_den=poly([-1 -1+1j*10 -1-1j*10]);
end
w=linspace(0,100,1024);
[H,w]=freqs(Hs_num,Hs_den,w);
plot(w/(2*pi),20*log10(abs(H)));
%xlabel('\omega (rad/s)'), ylabel('|H(\omega)|')
xlabel('f (Hz)'), ylabel('|H(f)|')
writeEPS('bilinear_example_differentiator')

myaxis=[-zlim zlim -zlim zlim -40 40];
subplot(221)
ak_bilinearPlotZPlane(Hs_num, Hs_den, Fs_values(1), zlim, numGridPoints);
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs_values(1));
ak_unityCircleInZPlane(Hz_num, Hz_den)
xlabel(''), ylabel('')
axis(myaxis);

subplot(222)
ak_bilinearPlotZPlane(Hs_num, Hs_den, Fs_values(2), zlim, numGridPoints);
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs_values(2));
ak_unityCircleInZPlane(Hz_num, Hz_den)
xlabel(''), ylabel(''), zlabel('')
axis(myaxis);

subplot(223)
ak_bilinearPlotZPlane(Hs_num, Hs_den, Fs_values(3), zlim, numGridPoints);
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs_values(3));
ak_unityCircleInZPlane(Hz_num, Hz_den)
axis(myaxis);

subplot(224)
ak_bilinearPlotZPlane(Hs_num, Hs_den, Fs_values(4), zlim, numGridPoints);
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs_values(4));
ak_unityCircleInZPlane(Hz_num, Hz_den)
zlabel('')
axis(myaxis);

writeEPS('impact_fs_on_bilinear')

clf;
for i=1:4
    eval(['subplot(22' num2str(i) ')'])
    [Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs_values(i));
    [H,W]=freqz(Hz_num, Hz_den,3000);
    if 0
        semilogx(W/pi,20*log10(abs(H)));
    else
        plot(W/pi,20*log10(abs(H)));
    end
    axis([0 1 -40 40])
    title(['F_s = ' num2str(Fs_values(i)) ' Hz'])
end
subplot(223), xlabel('Normalized f_N=\Omega/\pi')
subplot(224), xlabel('Normalized f_N=\Omega/\pi')

writeEPS('fs_on_bilinear_freqz','font12Only')