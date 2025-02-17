clear
close all
figure;
set(gcf,'position',[1648 733   716         348]);
set(gcf,'visible','off');
for sourcename1 = {'nrl300'}
    sourcename = upper(sourcename1{:});
    trans = sw06_event50_transmission(sourcename);
    datadir = '../mat/vla/';
    %datadir = '/Volumes/sw06 working disk/sw06_process_tools/sw06_event50_PE/mat_original/vla0/';
    figdir = '../figures/vla/';
    %files = dir([datadir,'SW50EVT50*.mat']);
    %x_axis = datenum([2006 8 17 20 0 0]):5/60/24:datenum([2006 8 17 24 0 0]);
    x_axis = 0:30;
    if strcmpi(sourcename,'J15')
        f0=250;
        transid = 'M';
    elseif strcmpi(sourcename,'NRL300')
        f0=300;
        transid = 'F';
    end
    
    shark_vla = sw06_rcvr_config('shark_vla');
    %z1=-[1:1:max(shark_vla.depth)];
    for ix_t = 4%: size(trans.time,1)
        vf=dir([sprintf('%sSW06_PE_%s_%s%d_VLA',datadir,sourcename,transid,ix_t),'.mat']);
        f1 = pwd;
        
        load([sprintf('%sSW06_PE_%s_%s%d_VLA',datadir,sourcename,transid,ix_t),'.mat']);
        if exist([sprintf('%sSW06_PE_%s_%s%d_VLA',datadir,sourcename,transid,ix_t),'.remote.mat'],'file')
            pe2=load([sprintf('%sSW06_PE_%s_%s%d_VLA',datadir,sourcename,transid,ix_t),'.remote.mat']);
            l1=length(pe.geotime);
            l2 = length(pe2.pe.geotime);
            pe.geotime = [pe.geotime, pe2.pe.geotime];
            pe.pressure(l1+1:l1+l2,:,:) = pe2.pe.pressure;
            [pe.geotime ixs] = sort(pe.geotime);
            pe.pressure = pe.pressure(ixs,:,:);
        end
        gt = (pe.geotime-min(pe.geotime))*60*24;
        if ~isfield(pe,'z')
            pe.z = [-1:-1:-77];
            pe.y=[0 0];
        end
        [xt yt]=meshgrid(gt, pe.z);
        
        
        n=0;
        for ix_y = floor(length(pe.y)/2) +[-1500:10:1500]
            n=n+1;
            if isfield(pe,'pressure')
                intens = 20*log10(abs(pe.pressure(:,:,ix_y)));
            end
            pcolor(xt, yt, intens');shading interp
            axes1= gca;
            set(gca,'ydir','normal')
            %datetick('x','keeplimits');
            set(gca,'xtick',x_axis);
            set(gca,'xlim',[gt(1) gt(end)]);
            set(gca,'fontsize',12,'fontweight','bold');
            ylabel('Depth(m)');
            xlabel('Geotime');
            %             title({['Received signal on Shark VLA during ',sourcename,' ',transid,num2str(ix_t)],...
            %                 [ datestr(pe.geotime(1)),' ~ ', datestr(pe.geotime(end))]});
            title([' (y=',num2str(pe.y(ix_y)),'m)']);
            caxis([-80 -50])
            caxis([-100 -60]);
            ca =colorbar
            set(ca,'fontweight','bold');
            axes(ca);
            title('dB','fontsize',10,'fontweight','bold');
            axes(axes1);
            %pause
            lj_saveSameSize(sprintf('%s/%s%d/SW06_PE_%s_%s%d_VLA_y%d.png',figdir,transid,ix_t,sourcename,transid,ix_t,n))
            %print('-dpng',sprintf('%sSW06_PE_%s_%s%d_VLA_y%d.png',figdir,sourcename,transid,ix_t,n))
        end
        
        
    end
end