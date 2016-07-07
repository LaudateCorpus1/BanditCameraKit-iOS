/*
 * Copyright (C) 2012-2016. TomTom International BV (http://tomtom.com).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

extension CameraRESTClient {

    /**
     Sends an HTTP request to the camera to get info about the current firmware
     
     - parameter completionHandler: Returns information about current and optional pending camera firmware
     
     - returns: RESTResponseBase object to enable chaining a failure block
     */
    public func getFirmwareInfo(completionHandler: (cameraFirmware: CameraFirmware) -> Void) -> RESTResponseBase {
        let url = apiRESTURLFor("firmware")
        let response = apiRESTClient.GET(url)
        
        response.successJSON { (responseObject) in
            guard let responseObject = responseObject else {
                response.setFailure(error: self.getRESTClientErrorObject("Failed to get camera firmware, response object is null"))
                response.callFailureBlock()
                return
            }

            let cameraFirmware = CameraFirmware()
            guard cameraFirmware.fromDictionary(responseObject) else {
                response.setFailure(error: self.getRESTClientErrorObject("Failed to get camera firmware, invalid response object"))
                response.callFailureBlock()
                return
            }
            
            completionHandler(cameraFirmware: cameraFirmware)
        }
        
        return response
    }

    /**
     Uploads new firmware update file to the camera
     
     - parameter fileSourcePath: Source file path of the firmware update file
     - parameter fileName:       File name of the firmware update file
     
     - returns: RESTUploadResponse object to enable chaining a progress block and a failure block
     */
    public func uploadFirmware(fileSourcePath: String, fileName: String) -> RESTUploadResponse {
        let url = apiRESTURLFor("firmware")
        return apiRESTClient.upload(url, fileSourcePath: fileSourcePath, fileName: fileName)
    }
}
