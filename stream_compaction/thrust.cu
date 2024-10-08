#include <cuda.h>
#include <cuda_runtime.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/scan.h>
#include "common.h"
#include "thrust.h"

namespace StreamCompaction {
    namespace Thrust {
        using StreamCompaction::Common::PerformanceTimer;
        PerformanceTimer& timer()
        {
            static PerformanceTimer timer;
            return timer;
        }
        /**
         * Performs prefix-sum (aka scan) on idata, storing the result into odata.
         */
        void scan(int n, int *odata, const int *idata) {
            timer().startGpuTimer();
            // TODO use `thrust::exclusive_scan`
            // example: for device_vectors dv_in and dv_out:
            // thrust::exclusive_scan(dv_in.begin(), dv_in.end(), dv_out.begin());
            
            //  Create thrust device vectors and copy input data to the device
            thrust::device_vector<int> dv_in(idata, idata + n);   
            thrust::device_vector<int> dv_out(n); 

            // Perform the exclusive scan using Thrust
            thrust::exclusive_scan(dv_in.begin(), dv_in.end(), dv_out.begin());

            timer().endGpuTimer();

            // Copy the results back to host memory (output array odata)
            thrust::copy(dv_out.begin(), dv_out.end(), odata);
            //cudaMemcpy(odata, dv_out.data().get(), n * sizeof(int), cudaMemcpyDeviceToHost);

        }
    }

}
