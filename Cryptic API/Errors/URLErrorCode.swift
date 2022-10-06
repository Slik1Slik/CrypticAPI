//
//  URLErrorCode.swift
//  Cryptic API
//
//  Created by Slik on 06.10.2022.
//

import Foundation

enum URLErrorCode: Int, RawRepresentable {
    
    case unknown                                      = -1
    case backgroundSessionRequiresSharedContainer     = -995
    case backgroundSessionInUseByAnotherProcess       = -996
    case backgroundSessionWasDisconnected             = -997
    case cancelled                                    = -999
    case badURL                                       = -1000
    case timedOut                                     = -1001
    case unsupportedURL                               = -1002
    case cannotFindHost                               = -1003
    case cannotConnectToHost                          = -1004
    case networkConnectionLost                        = -1005
    case dnsLookupFailed                              = -1006
    case httpTooManyRedirects                         = -1007
    case resourceUnavailable                          = -1008
    case notConnectedToInternet                       = -1009
    case redirectToNonExistentLocation                = -1010
    case badServerResponse                            = -1011
    case userCancelledAuthentication                  = -1012
    case userAuthenticationRequired                   = -1013
    case zeroByteResource                             = -1014
    case cannotDecodeRawData                          = -1015
    case cannotDecodeContentData                      = -1016
    case cannotParseResponse                          = -1017
    case internationalRoamingOff                      = -1018
    case callIsActive                                 = -1019
    case dataNotAllowed                               = -1020
    case requestBodyStreamExhausted                   = -1021
    case appTransportSecurityRequiresSecureConnection = -1022
    case fileDoesNotExist                             = -1100
    case fileIsDirectory                              = -1101
    case noPermissionsToReadFile                      = -1102
    case dataLengthExceedsMaximum                     = -1103
    case secureConnectionFailed                       = -1200
    case serverCertificateHasBadDate                  = -1201
    case serverCertificateUntrusted                   = -1202
    case serverCertificateHasUnknownRoot              = -1203
    case serverCertificateNotYetValid                 = -1204
    case clientCertificateRejected                    = -1205
    case clientCertificateRequired                    = -1206
    case cannotLoadFromNetwork                        = -2000
    case cannotCreateFile                             = -3000
    case cannotOpenFile                               = -3001
    case cannotCloseFile                              = -3002
    case cannotWriteToFile                            = -3003
    case cannotRemoveFile                             = -3004
    case cannotMoveFile                               = -3005
    case downloadDecodingFailedMidStream              = -3006
    case downloadDecodingFailedToComplete             = -3007
}

extension URLErrorCode {
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "The URL Loading System encountered an error that it can’t interpret."
        case .backgroundSessionRequiresSharedContainer:
            return "The shared container identifier of the URL session configuration is needed but hasn’t been set."
        case .backgroundSessionInUseByAnotherProcess:
            return "An app or app extension attempted to connect to a background session that is already connected to a process."
        case .backgroundSessionWasDisconnected:
            return "The app is suspended or exits while a background data task is processing."
        case .cancelled:
            return "An asynchronous load has been canceled."
        case .badURL:
            return "A malformed URL prevented a URL request from being initiated."
        case .timedOut:
            return "An asynchronous operation timed out."
        case .unsupportedURL:
            return "A properly formed URL couldn’t be handled by the framework."
        case .cannotFindHost:
            return "The host name for a URL couldn’t be resolved."
        case .cannotConnectToHost:
            return "An attempt to connect to a host failed."
        case .networkConnectionLost:
            return "A client or server connection was severed in the middle of an in-progress load."
        case .dnsLookupFailed:
            return "The host address couldn’t be found via DNS lookup."
        case .httpTooManyRedirects:
            return "A redirect loop has been detected or the threshold for number of allowable redirects has been exceeded (currently 16)."
        case .resourceUnavailable:
            return "A requested resource couldn’t be retrieved."
        case .notConnectedToInternet:
            return "A network resource was requested, but an internet connection hasn’t been established and can’t be established automatically."
        case .redirectToNonExistentLocation:
            return "A redirect was specified by way of server response code, but the server didn’t accompany this code with a redirect URL."
        case .badServerResponse:
            return "The URL Loading System received bad data from the server."
        case .userCancelledAuthentication:
            return "An asynchronous request for authentication has been canceled by the user."
        case .userAuthenticationRequired:
            return "Authentication is required to access a resource."
        case .zeroByteResource:
            return "A server reported that a URL has a non-zero content length, but terminated the network connection gracefully without sending any data."
        case .cannotDecodeRawData:
            return "Content data received during a connection request couldn’t be decoded for a known content encoding."
        case .cannotDecodeContentData:
            return "Content data received during a connection request had an unknown content encoding."
        case .cannotParseResponse:
            return "A task couldn’t parse a response."
        case .internationalRoamingOff:
            return "The attempted connection required activating a data context while roaming, but international roaming is disabled."
        case .callIsActive:
            return "A connection was attempted while a phone call is active on a network that doesn’t support simultaneous phone and data communication, such as EDGE or GPRS."
        case .dataNotAllowed:
            return "The cellular network disallowed a connection."
        case .requestBodyStreamExhausted:
            return "A body stream is needed but the client didn’t provide one."
        case .appTransportSecurityRequiresSecureConnection:
            return "App Transport Security disallowed a connection because there is no secure network connection."
        case .fileDoesNotExist:
            return "The specified file doesn’t exist."
        case .fileIsDirectory:
            return "A request for an FTP file resulted in the server responding that the file is not a plain file, but a directory."
        case .noPermissionsToReadFile:
            return "A resource couldn’t be read because of insufficient permissions."
        case .dataLengthExceedsMaximum:
            return "The length of the resource data exceeds the maximum allowed."
        case .secureConnectionFailed:
            return "An attempt to establish a secure connection failed for reasons that can’t be expressed more specifically."
        case .serverCertificateHasBadDate:
            return "A server certificate is expired, or is not yet valid."
        case .serverCertificateUntrusted:
            return "A server certificate was signed by a root server that isn’t trusted."
        case .serverCertificateHasUnknownRoot:
            return "A server certificate wasn’t signed by any root server."
        case .serverCertificateNotYetValid:
            return "A server certificate isn’t valid yet."
        case .clientCertificateRejected:
            return "A server certificate was rejected."
        case .clientCertificateRequired:
            return "A client certificate was required to authenticate an SSL connection during a request."
        case .cannotLoadFromNetwork:
            return "A request to load an item only from the cache could not be satisfied."
        case .cannotCreateFile:
            return "A download task couldn’t create the downloaded file on disk because of an I/O failure."
        case .cannotOpenFile:
            return "A download task was unable to open the downloaded file on disk."
        case .cannotCloseFile:
            return "A download task couldn’t close the downloaded file on disk."
        case .cannotWriteToFile:
            return "A download task was unable to write to the downloaded file on disk."
        case .cannotRemoveFile:
            return "A download task was unable to remove a downloaded file from disk."
        case .cannotMoveFile:
            return "A download task was unable to move a downloaded file on disk."
        case .downloadDecodingFailedMidStream:
            return "A download task failed to decode an encoded file during the download."
        case .downloadDecodingFailedToComplete:
            return "A download task failed to decode an encoded file after downloading."
        }
    }
}

extension URLError {
    
    var urlErrorCode: URLErrorCode {
        URLErrorCode(rawValue: self.errorCode) ?? .unknown
    }
}
