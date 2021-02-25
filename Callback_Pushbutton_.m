function Callback_Pushbutton_(src, evnt)

global dataPath GKey
global TP TS

idx = str2double(src.Tag);

switch idx
    case 1 % load key
       [fn, dataPath] = uigetfile('*.txt');
       junk = importdata(fullfile(dataPath, fn));
       GKey = junk{1};
       msg{1} = '         Google API Key has been loaded...';

    case 2 % load zip
       [fn] = uigetfile(fullfile(dataPath, '*.xlsx'));
       addressFN = fullfile(dataPath, fn);
       TP = readtable(addressFN, 'Sheet', 'People');
       TS = readtable(addressFN, 'Sheet', 'Satellite');
       msg{1} = '         Zip has been loaded...';
    case 3 % generate distance excel
        c = 0;
        for n = 1:size(TP, 1)
            name = TP{n, 1}{1};
            junk =  TP{n, 2};
            origin = num2str(junk);

            for m = 1:size(TS, 1)
                sat = TS{m, 1}{1};
                destination =  TS{m, 2}{1};

                url=['https://maps.googleapis.com/maps/api/directions/json?origin=' origin '&destination=' destination '&sensor=false &key=' GKey '&mode=driving'];
                direction = webread(url);

                d = direction.routes.legs.distance.text;
                t = direction.routes.legs.duration.text;

                c = c+1;
                Name{c} = name;
                Address{c} = origin;
                Satellite{c} = sat;
                SatlliteAddress{c} = destination;
                Distance{c} = d;
                DrivingTime{c} = t;
            end
        end
        Name = Name';
        Zip = Address';
        Satellite = Satellite';
        SatlliteAddress = SatlliteAddress';
        Distance = Distance';
        DrivingTime = DrivingTime';
        TT = table(Name, Zip, Satellite, SatlliteAddress, Distance, DrivingTime);
        writetable(TT, fullfile(dataPath, 'DrivingTime.xlsx'));
        
        msg{1} = '         Driving Time sheet has been generated...';
end

src.ForegroundColor = 'g';

msg{2} = ' ';
msgColor = 'g';
[hMB_saveData] = fun_messageBox('RadOnc Google Map API', msg, msgColor);