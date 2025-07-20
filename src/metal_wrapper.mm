#import <Metal/Metal.h>
#import <Foundation/Foundation.h>

#include "metal_wrapper.hpp"

// constructor can be empty
MetalComputeWrapper::MetalComputeWrapper() {}

Matrix MetalComputeWrapper::multiply(const Matrix& A, const Matrix& B) {
    int M = A.getRows();
    int K = A.getCols();
    int N = B.getCols();

    // empty result matrix
    Matrix C(M, N);

    // Metal setup
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    // device is here the GPU
    id<MTLCommandQueue> queue = [device newCommandQueue];
    // a queue for GPU orders

    // load shader
    NSError* error = nil;
    NSString* libPath = [[NSBundle mainBundle] pathForResource:@"matrix_multiply" ofType:@"metallib"];
    NSURL* libURL = [NSURL URLWithString:(libPath)];
    id<MTLLibrary> library = [device newLibraryWithURL:libURL error:&error];
    // loads the shader from a path
    id<MTLFunction> function = [library newFunctionWithName:@"matrix_multiply"];
    // in this shader the: "kernel matrix_multiply" function
    id<MTLComputePipelineState> pipeline = [device newComputePipelineStateWithFunction:function error:&error];
    // creates the pipeline for the shader


    // Buffer-size: size of matricies
    NSUInteger bytesA = A.getRows() * A.getCols() * sizeof(float);
    NSUInteger bytesB = B.getRows() * B.getCols() * sizeof(float);
    NSUInteger bytesC = C.getRows() * C.getCols() * sizeof(float);

    // allocate Memory
    id<MTLBuffer> bufferA = [device newBufferWithBytes:A.data().data() length:bytesA options:MTLResourceStorageModeShared];
    id<MTLBuffer> bufferB = [device newBufferWithBytes:B.data().data() length:bytesB options:MTLResourceStorageModeShared];
    id<MTLBuffer> bufferC = [device newBufferWithLength:bytesC options:MTLResourceStorageModeShared];

    // dimensions (M, K, N)
    uint32_t m = M, k = K, n = N;

    // execute shader
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

    [encoder setComputePipelineState:pipeline];
    [encoder setBuffer:bufferA offset:0 atIndex:0];
    [encoder setBuffer:bufferB offset:0 atIndex:1];
    [encoder setBuffer:bufferC offset:0 atIndex:2];
    [encoder setBytes:&m length:sizeof(uint32_t) atIndex:3];
    [encoder setBytes:&k length:sizeof(uint32_t) atIndex:4];
    [encoder setBytes:&n length:sizeof(uint32_t) atIndex:5];

    // thread-configuration
    MTLSize gridSize = MTLSizeMake(M * N, 1, 1);
    NSUInteger threadsPerGroup = pipeline.maxTotalThreadsPerThreadgroup;
    if (threadsPerGroup > gridSize.width) threadsPerGroup = gridSize.width;
    MTLSize threadgroupSize = MTLSizeMake(threadsPerGroup, 1, 1);

    // dispatching Thread and end queue
    [encoder dispatchThreads:gridSize threadsPerThreadgroup:threadgroupSize];
    [encoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];

    // copying result to CPU
    memcpy(C.data().data(), [bufferC contents], bytesC);

    return C;
}