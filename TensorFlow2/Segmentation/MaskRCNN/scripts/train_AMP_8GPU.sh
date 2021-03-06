#!/usr/bin/env bash

# Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

rm -rf /shared/results

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#mpirun \
#    -N 1  \
#    -H localhost:8 \
#    -bind-to none \
#    -map-by slot \
#    -x NCCL_DEBUG=VERSION \
#    -x LD_LIBRARY_PATH \
#    -x PATH \
#    -mca pml ob1 -mca btl ^openib \
#    --allow-run-as-root \
herringsinglenode \
    python ${BASEDIR}/../mask_rcnn_main.py \
        --mode="train_and_eval" \
        --checkpoint="/shared/model/resnet/resnet-nhwc-2018-02-07/model.ckpt-112603" \
        --eval_samples=5000 \
        --init_learning_rate=0.04 \
        --learning_rate_steps="3750,5000" \
        --model_dir="/shared/results/" \
        --num_steps_per_eval=462 \
        --total_steps=5625 \
        --train_batch_size=4 \
        --eval_batch_size=8 \
        --training_file_pattern="/shared/data/train*.tfrecord" \
        --validation_file_pattern="/shared/data/val*.tfrecord" \
        --val_json_file="/shared/data/annotations/instances_val2017.json" \
        --amp \
        --use_batched_nms \
        --xla \
        --nouse_custom_box_proposals_op
