function bunzip2(filename)
    % Decompress a .bz2 file using 7-Zip (Windows)
    fprintf('Decompressing %s with 7-Zip...\n', filename);

    % Path to 7z.exe (update if installed elsewhere)
    sevenZipPath = '"C:\Program Files\7-Zip\7z.exe"';

    % Run command: 7z e file.bz2 -o<outputdir> -y
    outDir = fileparts(filename);
    cmd = sprintf('%s e -y "%s" -o"%s"', sevenZipPath, filename, outDir);
    [status, result] = system(cmd);

    if status ~= 0
        error('7-Zip failed to decompress %s:\n%s', filename, result);
    end

    delete(filename); % remove the .bz2 archive
end