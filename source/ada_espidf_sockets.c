/*
 *  Copyright (C) 2026, Vadim Godunko
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include "lwip/sockets.h"

int __ada_sizeof_sockaddr_storage = sizeof(struct sockaddr_storage);

void __ada_Set_sockaddr_ip(struct sockaddr *self, in_addr_t address, in_port_t port)
{
    struct sockaddr_in *self_in = (struct sockaddr_in *)self;
    *self_in = (struct sockaddr_in){.sin_len = sizeof(struct sockaddr_storage),
                                    .sin_family = AF_INET,
                                    .sin_addr.s_addr = htonl(address),
                                    .sin_port = htons(port)};
}