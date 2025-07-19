#import <Metal/Metal.h>
#import <Foundation/Foundation.h>

#include "metal_wrapper.hpp"

// Konstruktor (kann leer bleiben)
MetalComputeWrapper::MetalComputeWrapper() {}

Matrix MetalComputeWrapper::multiply(const Matrix& A, const Matrix& B) {
    int M = A.getRows();
    int K = A.getCols();
    int N = B.getCols();

    // Leere Ergebnismatrix
    Matrix C(M, N);

    // Metal Setup
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    // device ist somit hier die GPU
    id<MTLCommandQueue> queue = [device newCommandQueue];
    // Eine queue für die GPU-Befehle

    // Shader laden
    NSError* error = nil;
    NSString* libPath = [[NSBundle mainBundle] pathForResource:@"matrix_multiply" ofType:@"metallib"];
    id<MTLLibrary> library = [device newLibraryWithFile:libPath error:&error];
    // lädt den shader von einem Pfad
    id<MTLFunction> function = [library newFunctionWithName:@"matrix_multiply"];
    // im shader der "kernel matrix_multiply"
    id<MTLComputePipelineState> pipeline = [device newComputePipelineStateWithFunction:function error:&error];
    // erstellt die Pipeline-Konfiguration für den shader


    // Buffer-Größen: die dimensionen der Arrays
    NSUInteger bytesA = A.getRows() * A.getCols() * sizeof(float);
    NSUInteger bytesB = B.getRows() * B.getCols() * sizeof(float);
    NSUInteger bytesC = C.getRows() * C.getCols() * sizeof(float);

    // Speicher anlegen
    id<MTLBuffer> bufferA = [device newBufferWithBytes:A.data().data() length:bytesA options:MTLResourceStorageModeShared];
    id<MTLBuffer> bufferB = [device newBufferWithBytes:B.data().data() length:bytesB options:MTLResourceStorageModeShared];
    id<MTLBuffer> bufferC = [device newBufferWithLength:bytesC options:MTLResourceStorageModeShared];

    // Dimensionen (M, K, N)
    uint32_t m = M, k = K, n = N;

    // Shader ausführen
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

    [encoder setComputePipelineState:pipeline];
    [encoder setBuffer:bufferA offset:0 atIndex:0];
    [encoder setBuffer:bufferB offset:0 atIndex:1];
    [encoder setBuffer:bufferC offset:0 atIndex:2];
    [encoder setBytes:&m length:sizeof(uint32_t) atIndex:3];
    [encoder setBytes:&k length:sizeof(uint32_t) atIndex:4];
    [encoder setBytes:&n length:sizeof(uint32_t) atIndex:5];

    // Thread-Konfiguration
    MTLSize gridSize = MTLSizeMake(M * N, 1, 1);
    NSUInteger threadsPerGroup = pipeline.maxTotalThreadsPerThreadgroup;
    if (threadsPerGroup > gridSize.width) threadsPerGroup = gridSize.width;
    MTLSize threadgroupSize = MTLSizeMake(threadsPerGroup, 1, 1);

    [encoder dispatchThreads:gridSize threadsPerThreadgroup:threadgroupSize];
    [encoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

    // Ergebnis zurück in C++
    memcpy(C.data().data(), [bufferC contents], bytesC);

    return C;
}