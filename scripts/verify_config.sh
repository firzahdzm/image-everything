#!/bin/bash

echo "=== Training Config Verification ==="
echo ""

# Check base templates
echo "1. Base Template Configs:"
echo "   Person template:"
grep "gradient_checkpointing" /workspace/scripts/core/config/base_diffusion_sdxl_person.toml
echo "   Style template:"
grep "gradient_checkpointing" /workspace/scripts/core/config/base_diffusion_sdxl_style.toml
echo ""

# Check generated configs
echo "2. Generated Configs (in /dataset/configs):"
if [ -d "/dataset/configs" ]; then
    for config in /dataset/configs/*.toml; do
        if [ -f "$config" ]; then
            echo "   File: $(basename $config)"
            grep "gradient_checkpointing" "$config" 2>/dev/null || echo "   (no gradient_checkpointing found)"
            grep "train_batch_size" "$config" 2>/dev/null || echo "   (no train_batch_size found)"
        fi
    done
else
    echo "   Directory /dataset/configs not found"
fi
echo ""

# Check if training is running
echo "3. Current Training Process:"
ps aux | grep python | grep train | grep -v grep || echo "   No training process found"
echo ""

# Check GPU
echo "4. GPU Status:"
nvidia-smi --query-gpu=memory.used,memory.total,utilization.gpu --format=csv,noheader,nounits
echo ""

echo "=== Recommendations ==="
echo "If gradient_checkpointing = true in generated config:"
echo "  → Stop training"
echo "  → Delete /dataset/configs/*.toml"
echo "  → Restart training"
echo ""
echo "Expected after fix:"
echo "  ✓ gradient_checkpointing = false"
echo "  ✓ train_batch_size = 16 (for 18 images)"
echo "  ✓ VRAM usage: 45-55GB"
echo "  ✓ Step time: 1.2-1.5s"
