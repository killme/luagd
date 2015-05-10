local ffi = require "ffi"

ffi.cdef [[
    typedef enum {
        GD_DEFAULT          = 0,
        GD_BELL,
        GD_BESSEL,
        GD_BILINEAR_FIXED,
        GD_BICUBIC,
        GD_BICUBIC_FIXED,
        GD_BLACKMAN,
        GD_BOX,
        GD_BSPLINE,
        GD_CATMULLROM,
        GD_GAUSSIAN,
        GD_GENERALIZED_CUBIC,
        GD_HERMITE,
        GD_HAMMING,
        GD_HANNING,
        GD_MITCHELL,
        GD_NEAREST_NEIGHBOUR,
        GD_POWER,
        GD_QUADRATIC,
        GD_SINC,
        GD_TRIANGLE,
        GD_WEIGHTED4,
        GD_METHOD_COUNT = 21
    } gdInterpolationMethod;

    typedef double (* interpolation_method )(double);

    typedef struct gdImageStruct {
        /* Palette-based image pixels */
        unsigned char **pixels;
        int sx;
        int sy;
        /* These are valid in palette images only. See also
        'alpha', which appears later in the structure to
        preserve binary backwards compatibility */
        int colorsTotal;
        int red[256];
        int green[256];
        int blue[256];
        int open[256];
        /* For backwards compatibility, this is set to the
        first palette entry with 100% transparency,
        and is also set and reset by the
        gdImageColorTransparent function. Newer
        applications can allocate palette entries
        with any desired level of transparency; however,
        bear in mind that many viewers, notably
        many web browsers, fail to implement
        full alpha channel for PNG and provide
        support for full opacity or transparency only. */
        int transparent;
        int *polyInts;
        int polyAllocated;
        struct gdImageStruct *brush;
        struct gdImageStruct *tile;
        int brushColorMap[256];
        int tileColorMap[256];
        int styleLength;
        int stylePos;
        int *style;
        int interlace;
        /* New in 2.0: thickness of line. Initialized to 1. */
        int thick;
        /* New in 2.0: alpha channel for palettes. Note that only
        Macintosh Internet Explorer and (possibly) Netscape 6
        really support multiple levels of transparency in
        palettes, to my knowledge, as of 2/15/01. Most
        common browsers will display 100% opaque and
        100% transparent correctly, and do something
        unpredictable and/or undesirable for levels
        in between. TBB */
        int alpha[256];
        /* Truecolor flag and pixels. New 2.0 fields appear here at the
            end to minimize breakage of existing object code. */
        int trueColor;
        int **tpixels;
        /* Should alpha channel be copied, or applied, each time a
        pixel is drawn? This applies to truecolor images only.
        No attempt is made to alpha-blend in palette images,
        even if semitransparent palette entries exist.
        To do that, build your image as a truecolor image,
        then quantize down to 8 bits. */
        int alphaBlendingFlag;
        /* Should the alpha channel of the image be saved? This affects
        PNG at the moment; other future formats may also
        have that capability. JPEG doesn't. */
        int saveAlphaFlag;

        /* There should NEVER BE ACCESSOR MACROS FOR ITEMS BELOW HERE, so this
        part of the structure can be safely changed in new releases. */

        /* 2.0.12: anti-aliased globals. 2.0.26: just a few vestiges after
        switching to the fast, memory-cheap implementation from PHP-gd. */
        int AA;
        int AA_color;
        int AA_dont_blend;

        /* 2.0.12: simple clipping rectangle. These values
        must be checked for safety when set; please use
        gdImageSetClip */
        int cx1;
        int cy1;
        int cx2;
        int cy2;

        /* 2.1.0: allows to specify resolution in dpi */
        unsigned int res_x;
        unsigned int res_y;

        /* Selects quantization method, see gdImageTrueColorToPaletteSetMethod() and gdPaletteQuantizationMethod enum. */
        int paletteQuantizationMethod;
        /* speed/quality trade-off. 1 = best quality, 10 = best speed. 0 = method-specific default.
        Applicable to GD_QUANT_LIQ and GD_QUANT_NEUQUANT. */
        int paletteQuantizationSpeed;
        /* Image will remain true-color if conversion to palette cannot achieve given quality.
        Value from 1 to 100, 1 = ugly, 100 = perfect. Applicable to GD_QUANT_LIQ.*/
        int paletteQuantizationMinQuality;
        /* Image will use minimum number of palette colors needed to achieve given quality. Must be higher than paletteQuantizationMinQuality
        Value from 1 to 100, 1 = ugly, 100 = perfect. Applicable to GD_QUANT_LIQ.*/
        int paletteQuantizationMaxQuality;
        gdInterpolationMethod interpolation_id;
        interpolation_method interpolation;
    } gdImage;
    typedef gdImage *gdImagePtr;

    typedef struct {
        int x, y;
        int width, height;
    } gdRect, *gdRectPtr;

    gdImagePtr gdImageCreateFromPngPtr(int, void *);
    void gdImageDestroy (gdImagePtr im);

    gdImagePtr gdImageCrop(gdImagePtr src, const gdRect *crop);
    gdImagePtr gdImageScale(const gdImagePtr src, const unsigned int new_width, const unsigned int new_height);

    void gdFree (void *m);
    void * gdImagePngPtr (gdImagePtr im, int *size);

    int gdImageSetInterpolationMethod(gdImagePtr im, gdInterpolationMethod id);

    void gdImageAlphaBlending (gdImagePtr im, int alphaBlendingArg);
    void gdImageSaveAlpha (gdImagePtr im, int saveAlphaArg);
    void gdImageCopy (gdImagePtr dst, gdImagePtr src, int dstX, int dstY,
        int srcX, int srcY, int w, int h);
    void gdImageCopyMerge (gdImagePtr dst, gdImagePtr src, int dstX, int dstY,
        int srcX, int srcY, int w, int h, int pct);

    gdImagePtr gdImageCreateTrueColor(int sx, int sy);

    int gdImageGetTrueColorPixel (gdImagePtr im, int x, int y);
    void gdImageInterlace (gdImagePtr im, int interlaceArg);
    void gdImageSetPixel (gdImagePtr im, int x, int y, int color);
    int gdImageGetTrueColorPixel (gdImagePtr im, int x, int y);
    int gdAlphaBlend (int dest, int src);
    int gdImageGetPixel (gdImagePtr im, int x, int y);
    void gdImageFlipHorizontal(gdImagePtr im);
    gdImagePtr gdImageClone (gdImagePtr src);
]]

return (ffi.load("libgd.so.3"))
